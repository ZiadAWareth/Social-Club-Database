-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema club
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema club
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `club` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `club` ;

-- -----------------------------------------------------
-- Table `club`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`department` (
  `D_ID` CHAR(8) NOT NULL,
  `Schedule` VARCHAR(20) NOT NULL,
  `SE_ID` CHAR(8) NOT NULL,
  `DepName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`D_ID`),
  INDEX `FK_Department_Employees` (`SE_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Department_Employees`
    FOREIGN KEY (`SE_ID`)
    REFERENCES `club`.`employees` (`E_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`transportation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`transportation` (
  `V_ID` CHAR(8) NOT NULL,
  `Driver` VARCHAR(20) NOT NULL,
  `Vehicle_Capacity` INT NOT NULL,
  `Destination` VARCHAR(15) NOT NULL,
  `Employees_Schedule` TIME NOT NULL,
  PRIMARY KEY (`V_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`employees` (
  `E_ID` CHAR(8) NOT NULL,
  `Fname` VARCHAR(15) NOT NULL,
  `Mname` VARCHAR(15) NOT NULL,
  `Lname` VARCHAR(15) NOT NULL,
  `Password` VARCHAR(15) NOT NULL,
  `City` VARCHAR(10) NOT NULL,
  `District` VARCHAR(10) NOT NULL,
  `Street` VARCHAR(10) NOT NULL,
  `Type_of_Job` VARCHAR(10) NOT NULL,
  `Working_Days` INT NOT NULL,
  `Salary` DOUBLE NOT NULL,
  `V_ID` CHAR(8) NULL DEFAULT NULL,
  `D_ID` CHAR(8) NULL DEFAULT NULL,
  PRIMARY KEY (`E_ID`),
  INDEX `FK_Employees_Transportation` (`V_ID` ASC) VISIBLE,
  INDEX `FK_Employees_Department` (`D_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Employees_Department`
    FOREIGN KEY (`D_ID`)
    REFERENCES `club`.`department` (`D_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Employees_Transportation`
    FOREIGN KEY (`V_ID`)
    REFERENCES `club`.`transportation` (`V_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`events` (
  `E_ID` CHAR(8) NULL DEFAULT NULL,
  `EV_ID` INT NOT NULL AUTO_INCREMENT,
  `transportation_capacity` INT NOT NULL,
  `date_of_event` DATE NOT NULL,
  `Transportation_Avaliability` TINYINT NOT NULL,
  `location_of_event` CHAR(20) NOT NULL,
  `capacity` INT NOT NULL,
  `joined_members` INT NOT NULL DEFAULT '0',
  `Name` VARCHAR(50) NOT NULL,
  `Price` INT NOT NULL,
  PRIMARY KEY (`EV_ID`),
  INDEX `FK_Events_Employees` (`E_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Events_Employees`
    FOREIGN KEY (`E_ID`)
    REFERENCES `club`.`employees` (`E_ID`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 40021
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`members`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`members` (
  `M_ID` CHAR(8) NOT NULL,
  `Fname` VARCHAR(15) NOT NULL,
  `Lname` VARCHAR(15) NOT NULL,
  `Age` INT NOT NULL,
  `Membership_Type` VARCHAR(9) NOT NULL,
  `Subscription` VARCHAR(10) NOT NULL,
  `Athlete_Status` TINYINT NOT NULL,
  PRIMARY KEY (`M_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`attended`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`attended` (
  `M_ID` CHAR(8) NOT NULL,
  `EV_ID` INT NOT NULL,
  PRIMARY KEY (`M_ID`, `EV_ID`),
  INDEX `attended_events_idx` (`EV_ID` ASC) VISIBLE,
  CONSTRAINT `attended_event`
    FOREIGN KEY (`EV_ID`)
    REFERENCES `club`.`events` (`EV_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Attended_Members`
    FOREIGN KEY (`M_ID`)
    REFERENCES `club`.`members` (`M_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`sports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`sports` (
  `Type` VARCHAR(15) NOT NULL,
  `Schedule` VARCHAR(15) NOT NULL,
  `Availibility_of_Joining` TINYINT NULL DEFAULT NULL,
  `E_ID` CHAR(8) NULL DEFAULT NULL,
  `Subscription` INT NULL DEFAULT NULL,
  PRIMARY KEY (`Type`, `Schedule`),
  INDEX `FK_Sports_Employees` (`E_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Sports_Employees`
    FOREIGN KEY (`E_ID`)
    REFERENCES `club`.`employees` (`E_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`courts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`courts` (
  `Number` CHAR(5) NOT NULL,
  `Type_of_sport` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Number`, `Type_of_sport`),
  INDEX `FK_Courts_Sports` (`Type_of_sport` ASC) VISIBLE,
  CONSTRAINT `FK_Courts_Sports`
    FOREIGN KEY (`Type_of_sport`)
    REFERENCES `club`.`sports` (`Type`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`bookingcourts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`bookingcourts` (
  `Type` VARCHAR(15) NOT NULL,
  `Courtnumber` CHAR(5) NOT NULL,
  `M_ID` CHAR(8) NOT NULL,
  `Date` VARCHAR(18) NOT NULL,
  PRIMARY KEY (`Date`),
  INDEX `court_member_idx` (`M_ID` ASC) VISIBLE,
  INDEX `court_idx` (`Type` ASC, `Courtnumber` ASC) VISIBLE,
  CONSTRAINT `court`
    FOREIGN KEY (`Type` , `Courtnumber`)
    REFERENCES `club`.`courts` (`Type_of_sport` , `Number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `court_member`
    FOREIGN KEY (`M_ID`)
    REFERENCES `club`.`members` (`M_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`halls`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`halls` (
  `H_ID` CHAR(8) NOT NULL,
  `Capacity` CHAR(8) NOT NULL,
  `Type` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`H_ID`, `Type`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`bookinghalls`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`bookinghalls` (
  `H_ID` CHAR(8) NULL DEFAULT NULL,
  `M_ID` CHAR(8) NULL DEFAULT NULL,
  `DATE` VARCHAR(18) NOT NULL,
  PRIMARY KEY (`DATE`),
  INDEX `MEMBERHALLS_idx` (`M_ID` ASC) VISIBLE,
  INDEX `HALLSTYPE_idx` (`H_ID` ASC) VISIBLE,
  CONSTRAINT `HALLSTYPE`
    FOREIGN KEY (`H_ID`)
    REFERENCES `club`.`halls` (`H_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `MEMBERHALLS`
    FOREIGN KEY (`M_ID`)
    REFERENCES `club`.`members` (`M_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`complaints`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`complaints` (
  `C_ID` INT NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(800) NOT NULL,
  `E_ID` CHAR(8) NULL DEFAULT NULL,
  `M_ID` CHAR(8) NULL DEFAULT NULL,
  `Answered` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`C_ID`),
  INDEX `FK_Complaints_Employees1` (`E_ID` ASC) VISIBLE,
  INDEX `FK_Complaints_Members` (`M_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Complaints_Employees1`
    FOREIGN KEY (`E_ID`)
    REFERENCES `club`.`employees` (`E_ID`),
  CONSTRAINT `FK_Complaints_Members`
    FOREIGN KEY (`M_ID`)
    REFERENCES `club`.`members` (`M_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`feedback` (
  `C_ID` INT NOT NULL,
  `E_ID` CHAR(8) NOT NULL,
  `Feedback` VARCHAR(800) NOT NULL,
  PRIMARY KEY (`C_ID`, `E_ID`),
  INDEX `FK_Feedback_Employees` (`E_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Feedback_Employees`
    FOREIGN KEY (`E_ID`)
    REFERENCES `club`.`employees` (`E_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`login`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`login` (
  `ID` INT NOT NULL,
  `Passkey` VARCHAR(30) NOT NULL,
  `TypeOfUser` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`ID`, `Passkey`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`plays`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`plays` (
  `Type_of_Sports` VARCHAR(15) NOT NULL,
  `Schedule` VARCHAR(15) NOT NULL,
  `M_ID` CHAR(8) NOT NULL,
  PRIMARY KEY (`Type_of_Sports`, `Schedule`, `M_ID`),
  INDEX `memberplay_idx` (`M_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Plays_Sports`
    FOREIGN KEY (`Type_of_Sports` , `Schedule`)
    REFERENCES `club`.`sports` (`Type` , `Schedule`),
  CONSTRAINT `memberplay`
    FOREIGN KEY (`M_ID`)
    REFERENCES `club`.`members` (`M_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`resources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`resources` (
  `Type_of_Goods` VARCHAR(30) NOT NULL,
  `Price` INT NOT NULL,
  `Quantity` INT NOT NULL,
  UNIQUE INDEX `IX_Resources` (`Type_of_Goods` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`request` (
  `E_ID` CHAR(8) NOT NULL,
  `Type_of_Goods` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`E_ID`, `Type_of_Goods`),
  INDEX `FK_Request_Request1` (`Type_of_Goods` ASC) VISIBLE,
  CONSTRAINT `FK_Request_Request`
    FOREIGN KEY (`E_ID`)
    REFERENCES `club`.`employees` (`E_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FK_Request_Request1`
    FOREIGN KEY (`Type_of_Goods`)
    REFERENCES `club`.`resources` (`Type_of_Goods`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `club`.`ride_member`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `club`.`ride_member` (
  `M_ID` CHAR(8) NOT NULL,
  `V_ID` CHAR(8) NOT NULL,
  PRIMARY KEY (`M_ID`, `V_ID`),
  INDEX `FK_Ride_Member_Transportation` (`V_ID` ASC) VISIBLE,
  CONSTRAINT `FK_Ride_Member_Members`
    FOREIGN KEY (`M_ID`)
    REFERENCES `club`.`members` (`M_ID`),
  CONSTRAINT `FK_Ride_Member_Transportation`
    FOREIGN KEY (`V_ID`)
    REFERENCES `club`.`transportation` (`V_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `club` ;

-- -----------------------------------------------------
-- procedure AddAccount
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddAccount`(IN IDs INT, IN P varchar(20))
BEGIN
INSERT INTO `club`.`login` (`ID`, `Passkey`,`TypeOfUser`) VALUES (IDs,P,'Member');
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddAdmin
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddAdmin`(IN empID INT,IN fname varchar(20),IN mname varchar(20),IN lname varchar(20), IN pass varchar(20),IN cit varchar(20),IN dist varchar(20),IN str varchar(20),IN WDays INT,IN pay INT,IN depID INT)
BEGIN
INSERT INTO `club`.`employees` (`E_ID`, `Fname`,`Mname`, `Lname`, `Password`, `City`, `District`, `Street`,`Type_of_Job`,`Working_Days`,`Salary`,`D_ID`) VALUES (empID, fname,mname, lname,pass,cit,dist,str,"Admin",WDays,pay,depID);
INSERT INTO `club`.`login` (`ID`, `Passkey`,`TypeOfUser`) VALUES (empID,pass,"Admin");
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddMember
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddMember`(IN ID INT,IN fname varchar(20),IN lname varchar(20), IN AGE INT , IN substype varchar(20),IN fees INT,IN Athstatus INT)
BEGIN
INSERT INTO `club`.`members` (`M_ID`, `Fname`, `Lname`, `Age`, `Membership_Type`, `Subscription`, `Athlete_Status`) VALUES (ID, fname, lname , AGE,substype,fees,Athstatus);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Add_Event
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Event`(in Eid char(8), in TC int, in evdate date,in TA tinyint,in Location char(20),in Evname varchar(50),in Evcapacity int, in pr INT)
BEGIN
 insert into events(E_ID,transportation_capacity,date_of_event,Transportation_Avaliability,location_of_event,Name,capacity,Price) values(Eid,TC,evdate,TA,Location,Evname,Evcapacity,pr);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AdminDeleteCancellation
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdminDeleteCancellation`()
BEGIN
delete from members where Membership_Type="cancelled" ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Apply_Sports
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Apply_Sports`(IN Type varchar(15),IN schedule varchar(15),IN MID char(8))
BEGIN
insert into plays value(Type,schedule,MID);
update members set Athlete_Status=1 where M_ID=MID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Cancel_Subscription
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Cancel_Subscription`(IN id CHAR(8))
BEGIN
update members set Membership_Type= 'Cancelled' , Subscription='0' where M_ID= id ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckPresenceofMember
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckPresenceofMember`(IN IDs INT,OUT ex INT, OUT exlog INT)
BEGIN
 SELECT  EXISTS(SELECT * FROM members WHERE M_ID = IDs)INTO @ex;
  SELECT  EXISTS(SELECT * FROM login WHERE ID = IDs)INTO @exlog;
select @ex AS exist;
select @exlog AS exist2;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DeleteMember
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteMember`(IN ID INT)
BEGIN
    DELETE FROM members WHERE M_ID= ID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure FindUserType
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `FindUserType`(IN IDin INT, IN pass varchar(50))
BEGIN
SELECT * FROM login WHERE ID = IDin AND Passkey=pass;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetCancelledMembers
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCancelledMembers`()
BEGIN
Select M_ID,Fname,Lname From members where Membership_Type="cancelled" ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetScheduleOfSports
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetScheduleOfSports`(IN typ VARCHAR(15))
BEGIN
select Schedule From sports where Type = typ  ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_Complaint
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Complaint`()
BEGIN
select C_ID , m.M_ID,c.M_ID, message, Fname from members m , complaints c where c.M_ID = m.M_ID and answered = '0'
limit 1;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_CourtNumber
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_CourtNumber`(IN Type VARCHAR(15))
BEGIN
SELECT Number from courts where Type_of_sport=Type ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_Employee
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Employee`()
BEGIN
select E_ID ,Fname,Lname from employees;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_Events
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Events`()
BEGIN
select EV_ID, date_of_event,Transportation_Avaliability,location_of_event, capacity,joined_members,Name,Price from events;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_Halls
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Halls`()
BEGIN
select distinct H_ID ,Type from halls; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_Most_Paid_Dep
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Most_Paid_Dep`()
BEGIN
SELECT DepName, count(*) num
FROM department d, employees e
WHERE e.D_ID=d.D_ID
GROUP BY DepNAME
HAVING AVG (Salary) > 5000;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_Sports_Courts
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Sports_Courts`()
BEGIN
select distinct Type_of_sport from courts;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure IncrementResources
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `IncrementResources`(IN TypeOfGoods VARCHAR(30),IN pric INT,IN quan INT)
BEGIN
UPDATE `club`.`resources` SET Price = Price +pric , Quantity =Quantity +quan  WHERE Type_of_Goods=TypeOfGoods;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Insert_Complaint
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Complaint`(in complaint varchar(800),in MID char(8))
BEGIN
insert into complaints (message,M_ID) values (complaint,MID);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Insert_Courts
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Courts`(IN Type varchar(15),IN court char(5),IN M_ID char(8),IN DATE varchar(18))
BEGIN
insert into bookingcourts value(Type,court,M_ID,DATE);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Insert_Feedback
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Feedback`(IN feedback varchar(800), IN CID char(8), IN EID char(8),in admin char(8))
BEGIN
insert into feedback(C_ID,E_ID,Feedback) values(CID,EID,feedback);
 UPDATE complaints
SET answered = '1' 
, E_ID = admin
WHERE C_ID=CID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Insert_Halls
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_Halls`(IN H_ID char(8),IN M_ID char(8),IN DATE varchar(18))
BEGIN
insert into bookinghalls value(H_ID,M_ID,DATE);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure IsEmployee
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `IsEmployee`(IN IDs INT,OUT ex INT)
BEGIN
 SELECT  EXISTS(SELECT * FROM employees WHERE E_ID = IDs)INTO @ex;
select @ex AS exist;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure IsMember
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `IsMember`(IN IDs INT,OUT ex INT)
BEGIN
 SELECT  EXISTS(SELECT * FROM members WHERE M_ID = IDs)INTO @ex;
select @ex AS exist;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure IsRequestedBefore
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `IsRequestedBefore`(IN IDs INT,IN typ varchar(30),OUT ex INT)
BEGIN
 SELECT  EXISTS(SELECT * FROM request WHERE E_ID = IDs AND Type_of_Goods=typ)INTO @ex;
select @ex AS exist;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Join_Event
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Join_Event`(in MID char(8),EV int ,in chk tinyint)
BEGIN
insert into attended (M_ID,EV_ID) select MID,EV
WHERE 0 < (select count(*) from events where EV_ID=EV and capacity > joined_members and(chk =1 and Transportation_Avaliability > 0 or chk = 0));
update events 
set Transportation_Avaliability=Transportation_Avaliability-1 where 
EV_ID=EV and capacity > joined_members and chk =1 and Transportation_Avaliability > 0;
update events
set joined_members=joined_members+1 where 
EV_ID=EV and capacity > joined_members and (chk =1 and Transportation_Avaliability > 0 or chk = 0);
select * from attended where M_ID=MID and EV_ID=EV;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Report_Sub
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Report_Sub`()
BEGIN
SELECT Membership_Type,Round((count(*)/ (SELECT count(*) FROM members))*100,1) NUM
FROM members
group by Membership_Type;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RequestingResources
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RequestingResources`(IN EmplyeeID CHAR(8),IN TypeOfGoods VARCHAR(30),IN pric INT,IN quan INT)
BEGIN
INSERT INTO `club`.`resources` (`Type_of_Goods`,`Price`,`Quantity`) VALUES (TypeOfGoods, pric,quan);
UPDATE `club`.`resources` SET Price = Price +pric , Quantity =Quantity +quan  WHERE Type_of_Goods=TypeOfGoods;
INSERT INTO `club`.`request` (`E_ID`, `Type_of_Goods`) VALUES (EmplyeeID, TypeOfGoods);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Select member with ID
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Select member with ID`(ID int)
BEGIN
SELECT * from members WHERE M_ID='ID';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Select_Trainer_Type
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Select_Trainer_Type`()
BEGIN
select Type , count(*) Number  from employees e ,sports s 
where type_of_job = "Trainer" and e.E_ID = s.E_ID

group by Type;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure SelectmemberwithID
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SelectmemberwithID`(IN ID INT)
BEGIN
SELECT * from members WHERE M_ID = ID ;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure TypeOfSports
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `TypeOfSports`()
BEGIN
select distinct Type From sports;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ViewFeedback
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewFeedback`(IN id char(8))
BEGIN
select Feedback from feedback where E_ID=id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ViewMembership
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewMembership`(IN ID INT)
BEGIN
Select Membership_Type,Subscription FROM members WHERE M_ID= ID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure ViewSalary
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ViewSalary`(IN ID INT)
BEGIN
Select Salary FROM employees WHERE E_ID= ID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure View_Res_Stats
-- -----------------------------------------------------

DELIMITER $$
USE `club`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `View_Res_Stats`()
BEGIN
Select sum(Quantity) Q,sum(Price) P
from resources;

END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
