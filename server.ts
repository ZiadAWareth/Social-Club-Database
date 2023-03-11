//Requiring express and mysql
import express from "express";
const app = express();
import path from "path";
require("dotenv").config();
const cors = require('cors');
//Requiring Body Parser
const bodyparser= require("body-parser");
app.use(bodyparser.urlencoded(({extended:true})))
//Making connection
const mysql = require("mysql2");

var con = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});


app.use(express.json());
app.set("view engine", "ejs");
app.use(cors({origin: '*'}));
const PORT = 5000;


// Add Account
app.get("/AddAccounts/:memberId/:pass", async (req, res, next) => {
  const id = req.params.memberId;
  const passw =req.params.pass;
  const [rows,fields] = await con.promise().query(
    "CALL AddAccount('" + id + "', '" + passw + "');"
);
console.log(rows[0]);
res.status(200).json(rows);
});


//New Account SignUp
app.get("/SignUpAccount/:memberId/:pass", async (req, res, next) => {
  const id = req.params.memberId;
  const pass =req.params.pass;
  const [rows,fields] = await con.promise().query(
    "CALL CheckPresenceofMember('" + id + "',@ex,@exs);"
    //('" + id + "', '" + pass + "');"
  );
  console.log(rows);
  var ex_member = rows[0][0].exist;
  var ex_acc = rows[1][0].existlog;
  res.status(200).json(rows);
});

//Signing in different views
app.post("/loginCheck",async(req,res,next)=>{
  const id= req.body.id
  const pass = req.body.pass
  const [rows, fields] = await con.promise().query(
    "CALL FindUserType('" + id + "', '" + pass + "');"
  );
  res.status(200).json(rows);
});
//get all sports
app.get("/sports", async (req, res, next) => {
  const [rows, fields] = await con.promise().query(
    "Select DISTINCT TYPE FROM sports"
  );
  res.status(200).json(rows);
});

//Searching for a member
app.get("/member/:memberId", async (req, res, next) => {
  const id = req.params.memberId
  
  const [rows, fields] = await con.promise().query(
   // sqlquery,[id]
   "Call SelectmemberwithID("+id+")"
    //con.query(sqlquery,[id])
  );
  console.log(rows)
  res.status(200).json(rows);
});

//Deleting a member
app.get("/Deletemember/:memberId", async (req, res, next) => {
  const id = req.params.memberId
  const [rows, fields] = await con.promise().query(
    "Call DeleteMember("+id+")"
  );
  res.status(200).json(rows);
});

//Adding A Member
app.get("/addmembers/:memberId/:FirstName/:LastName/:Age/:substype/:fees/:athletestatus", async (req, res, next) => {
  const id = req.params.memberId
  const FN = req.params.FirstName
  const LN = req.params.LastName
  const age = req.params.Age
  const ST = req.params.substype
  const Fe = req.params.fees
  // const pa = req.params.pass
  const As = req.params.athletestatus
  if(As==="Yes")
 {var Athstatus=1;}
  else
 {var Athstatus=0;}
 
 
  const [rows, fields] = await con.promise().query(
    "Call AddMember('" + id + "', '" + FN + "', '" + LN + "', '" + age + "', '" + ST + "','" + Fe + "','" + Athstatus + "')"
  );
  res.status(200).json(rows);
});


//Adding An Admin

app.get("/addadmins/:empId/:FirstName/:MiddleName/:LastName/:city/:dist/:str/:pass/:workdays/:salary/:Did", async (req, res, next) => {
  const id = req.params.empId
  const FN = req.params.FirstName
  const MN = req.params.MiddleName
  const LN = req.params.LastName
  const cit = req.params.city
  const distr = req.params.dist
  const ST = req.params.str
  const pass = req.params.pass
  const WD = req.params.workdays
  const S = req.params.salary
  const DepID = req.params.Did
 
  const [rows, fields] = await con.promise().query(
    "Call AddAdmin('" + id + "', '" + FN + "', '" + MN + "', '" + LN + "','" + pass + "', '" + cit + "','" + distr + "','" + ST + "','" + WD + "','" + S + "','" + DepID + "')"
  );
  res.status(200).json(rows);
});

///////////////////////////////////Request Resources//////////////////////////////////////////////////
app.get("/IsRequested/:empID/:typ", async (req, res, next) => {
  const id = req.params.empID
  const type = req.params.typ
  const [rows, fields] = await con.promise().query(
   "CALL IsRequestedBefore('" + id + "', '" + type+ "',@ex);"
  );
  console.log(rows[0][0]);
  res.status(200).json(rows);
});

app.get("/IncResources/:typ/:p/:q", async (req, res, next) => {
  const type = req.params.typ
  const price = req.params.p
  const quantity = req.params.q
  const [rows, fields] = await con.promise().query(
   "CALL IncrementResources('" + type + "', '" +price+ "', '" +quantity+ "');"
  );
  console.log(rows[0]);
  res.status(200).json(rows);
});

app.get("/RequestRes/:employeeId/:TypeOfGoods/:Quantity/:Price", async (req, res, next) => {
  const id = req.params.employeeId
  const TypeOfG = req.params.TypeOfGoods
  const quan = req.params.Quantity
  const p = req.params.Price
  const [rows, fields] = await con.promise().query(
  
    "call RequestingResources('"+id+"','"+TypeOfG+"','"+p+"','"+quan+"')"
  );
  console.log(rows);
  res.status(200).json(rows);
});
// app.post("/addmembers", async (req, res, next) => {
//  if(req.body.Astatus==="Yes")
//  {var Athstatus=1;}
//  else
//  {var Athstatus=0;}
//   const [rows, fields] = await con.promise().query(
//     "Call AddMember('" + req.body.id + "', '" + req.body.fname + "', '" + req.body.lname + "', '" + req.body.AGE + "', '" + req.body.substype + "','" + req.body.fees + "','" + req.body.password + "','" + Athstatus + "')"
//     );
// });
////////////////////////////////////////Member Submit Complaint//////////////////////////////////////////
//Submit Complaint

app.post("/complaint/newComplaint",async (req,res,next)=>{
  try{ const MemberID= req.body.MemberID
   const MemberName = req.body.MemberName
   const Complaint = req.body.Complaint
   const [rows, fields] = await con.promise().query(
     `call Insert_Complaint("${Complaint}","${MemberID}");`
   );
   res.status(200).json(rows);
  }catch(e){
   console.error(e)
   res.status(500).send();
  }
 });

////////////////////////////////////////Sports//////////////////////////////////////////////////////////
app.get("/Register", async (req, res) => {
  const [rows, fields] = await con.promise().query(
    "call TypeOfSports()"
   );
   app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
   res.render("Register",{type:rows[0]});

  });

app.post("/applysport", async (req, res, next) => {
  const ID = req.body.ID
  const Type= req.body.Type
  const schedule=req.body.schedule
  const [rows, fields] = await con.promise().query(
    `call Apply_Sports("${Type}","${schedule}","${ID}")`
  );
  res.status(200).json(rows);
});


app.get("/ShowSportsSchedule/:type", async (req, res, next) => {
  const Ty = req.params.type
  const [rows, fields] = await con.promise().query(
   `call GetScheduleOfSports("${Ty}")`
  );
  res.status(200).json(rows);
});
////////////////////////////////////////Booking Courts//////////////////////////////////////////////////////////
app.post("/bookcourt", async (req, res, next) => {
  try{const ID = req.body.ID
  const datepicker= req.body.datepicker
  const Type= req.body.Type
  const court=req.body.court
  const [rows, fields] = await con.promise().query(
    `call Insert_Courts("${Type}","${court}","${ID}","${datepicker}")`
  );
  res.status(200).json(rows);}
  catch(e){
    console.error(e)
    res.status(500).send();
  }
});

app.get("/getcourts/:type",async(req,res)=>{
  const Type= req.params.type
  const [r, f] = await con.promise().query(
    `call Get_CourtNumber("${Type}");`
    );
    res.status(200).json(r);
});

app.get("/bookingcourts",async(req,res)=>{
  const [rows, fields] = await con.promise().query(
    "call Get_Sports_Courts();"
  );
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  res.render('Booking_Courts',{sport:rows[0]});

});
////////////////////////////////////////Booking Halls//////////////////////////////////////////////////////////
app.post("/bookhall", async (req, res, next) => {
  const ID = req.body.ID
  const datepicker= req.body.datepicker
  const hallType= req.body.hallType
  const [rows, fields] = await con.promise().query(
    `call Insert_Halls("${hallType}","${ID}","${datepicker}")`
  );
  res.status(200).json(rows);
});


app.get("/bookinghalls",async(req,res)=>{
  const [rows, fields] = await con.promise().query(
    "call Get_Halls()"
  );
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  res.render('Booking Hall',{halls:rows[0]});
});
/////////////////////////////////Adding an Event/////////////////////////////////////////////////////////////
// app.post("/AddEvent", async (req, res, next) => {
//   const [rows, fields] = await con.promise().query(
     
//     "INSERT INTO `club`.`events` (`E_ID`, `EV_ID`, `transportation_capacity`, `date_of_event`, `Transportation_Avaliability`, `location_of_event`, `capacity`) VALUES ('" + req.body.E_ID + "', '" + req.body.EV_ID + "', '" + req.body.transportation_capacity + "', '" + req.body.date_of_event + "', '" + req.body.Transportation_Avaliability + "','" + req.body.location_of_event+ "','" + req.body.capacity +  "')"
//     );
//   res.status(200).json(rows);
// });
app.post("/Event/newEvent",async (req,res,next)=>{
  try{const Location =req.body.Location
  const Date =req.body.Date
  const Capacity =req.body.capacity
  const transportation=req.body.transportation
  const transcap=req.body.transcap
  const name = req.body.name
  const id = req.body.id
  const p = req.body.price
  const [rows, fields] = await con.promise().query(
    `call Add_Event("${id}",${transcap},"${Date}","${transportation}","${Location}","${name}","${Capacity}","${p}");`
  );
  console.log(rows)
    res.status(200).json(rows);
  }catch(e){
    console.error(e)
    res.status(500).send();
  }
  });
//view salary for employees
app.get("/employee/:Employeeid", async (req, res, next) => {
  const id = req.params.Employeeid
  const [rows, fields] = await con.promise().query(
    "Call ViewSalary("+id+")"
    );
  res.status(200).json(rows);
});

//viewfeedback
app.get("/Feedback/:EmpId", async(req,res,next)=>{
  try{const id = req.params.EmpId
  const [rows, fields] = await con.promise().query(
    "Call ViewFeedback('"+id+"')"
  );
  console.log(rows);
  res.status(200).json(rows);
  }catch(e)
  {
    console.error(e)
    res.status(500).send();
  }
});
//View Member Fees and subscription type
app.get("/ViewMemberShipDetails/:memberId", async (req, res, next) => {
  const id = req.params.memberId
  const [rows, fields] = await con.promise().query(
    "Call ViewMembership("+id+")"
  );
  res.status(200).json(rows);
});

//Update Membership Type 
app.get("/UpdateMembership/:memberId/:membership", async (req, res, next) => {
  const id = req.params.memberId
  const memberShip= req.params.membership
  const [r,f] = await con.promise().query(
    "Call CheckPresenceofMember('" + id + "',@ex,@exs)"
  );
  var ex_member = r[0][0].exist;
  var ex_acc = r[1][0].exist2;
  console.log(r)
   if(ex_member ===1 && ex_acc === 1)
   {
  const [rows, fields] = await con.promise().query(
    "Update members set Membership_Type='"+memberShip+"' WHERE M_ID="+id
  );
  if(memberShip=="regular")
  {
    const [rows, fields] = await con.promise().query(
      "Update members set Subscription= '350000' WHERE M_ID="+id
    );

  }
  else if(memberShip=="VIP")
  {
    const [rows, fields] = await con.promise().query(
      "Update members set Subscription= '500000' WHERE M_ID="+id
    );

  }
  else{
    const [rows, fields] = await con.promise().query(
      "Update members set Subscription= '100000' WHERE M_ID="+id
    );
  }
  res.status(200).json(rows);
}

}
// else{
//   res.send(exists);
// }
)



//Change Password
app.get("/ChangePassword/:memberId/:newPass/:rewritePass", async (req, res, next) => {
  const id = req.params.memberId
  const newpass = req.params.newPass
  const rewritepass = req.params.rewritePass
  const [rows, fields] = await con.promise().query(
   "Update members set Password= '"+newpass+"' WHERE M_ID="+id
  );
  res.status(200).json(rows);
});

//Cancel Subscription by Member
app.get("/CancelSubscription/:memberId", async (req, res, next) => {

  const id = req.params.memberId

 
  const [rows, fields] = await con.promise().query(
   "call Cancel_Subscription('"+id+"')"
  );
  res.status(200).json(rows);
});

//Check presence of member in members Table
app.get("/IsAMember/:memberId", async (req, res, next) => {
  const id = req.params.memberId
  const [rows, fields] = await con.promise().query(
   "CALL IsMember('" + id + "',@ex);"
  );
  console.log(rows[0][0]);
  res.status(200).json(rows);
});

//Check presence of employee in employee Table
app.get("/IsAnEmployee/:empId", async (req, res, next) => {
  const id = req.params.empId
  const [rows, fields] = await con.promise().query(
   "CALL IsEmployee('" + id + "',@ex);"
  );
  console.log(rows[0][0]);
  res.status(200).json(rows);
});


/////////////////////////Answer Complaints of a Member//////////////////////////////////////
//answerComplaint
app.get("/Complaint", async(req,res)=>{
  try{
  const [rows, fields] = await con.promise().query(
    "call Get_Complaint();"
  );
  res.status(200).json(rows);
  }catch(e){
    console.error(e)
    res.status(500).send();
  }
});

app.post("/Complaint/:CID/Feedback", async (req, res, next) => {
 try{ console.log(req.body)
  const id = req.body.EmpID
  const message = req.body.message
  const complaint = req.params.CID
  const admin = req.body.adminID
  console.log(`call Insert_Feedback("${message}","${complaint}","${id}","${admin}")`)
  const [rows, fields] = await con.promise().query(
    `call Insert_Feedback("${message}","${complaint}","${id}","${admin}")`
  );
  res.status(200).json(rows);
}catch(e){
  console.error(e)
  res.status(500).send();
}
});
app.get("/AnswerComplaints",async(req,res)=>{
  try{
    const [rows, fields] = await con.promise().query(
    "call Get_Employee()"
  );
  res.render('Answer_Complaints',{employee:rows[0]});
  }catch(e){
    console.error(e)
    res.status(500).send();
  }
});

/////////////////////////Deleting Cancelled Members//////////////////////////////////////
app.get("/DeleteCancelledMember", async (req, res, next) => {

  const [rows, fields] = await con.promise().query(
   "call GetCancelledMembers();"
  );
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  res.render('DeleteCancelledMembers',{members:rows[0]});
  console.log(rows[0]);
});

app.get("/DeletecancelledMemberShip", async (req, res, next) => {

  const [rows, fields] = await con.promise().query(
   "call AdminDeleteCancellation()"
  );
  res.status(200).json(rows);
});

////////////////////////////////////////////ADD EVENT///////////////////////////////////////////////
app.post("/Event/newEvent",async (req,res,next)=>{
  try{const Location =req.body.Location
  const Date =req.body.Date
  const Capacity =req.body.capacity
  const transportation=req.body.transportation
  const transcap=req.body.transcap
  const name = req.body.name
  const id = req.body.id
  const [rows, fields] = await con.promise().query(
    `call Add_Event("${id}",${transcap},"${Date}","${transportation}","${Location}","${name}","${Capacity}");`
  );
  console.log(rows)
    res.status(200).json(rows);
  }catch(e){
    console.error(e)
    res.status(500).send();
  }
  });


///////////////////////////////////Join event/////////////////////////////////////////////////////////
app.post("/MemberJoinEvent",async(req,res,next)=>{
  try {
  const Mid = req.body.id
  const EvID = req.body.EventID
  const trans= req.body.transportation

  const [rows, fields] = await con.promise().query(
    `call Join_Event("${Mid}",${EvID},${trans});`
  );
  console.log(rows)
  if(rows[0].length){
    res.status(200).json(rows);
  }
    res.status(500).json(rows);
  } catch (e) {
    console.error(e)
    res.status(500).send();
  }
});

///////////////////////////////////////////STASTICAL////////////////////////////////////

app.get("/Member_Type_Sub", async (req, res) => {
  const [rows, fields] = await con.promise().query(
    
    "call Report_Sub()"
   );
   app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
   res.render("Member_Type_Sub",{sub:rows[0]});

  });

/////////////////////////////////////////// Stastical Resources/////////////////////////

app.get("/ResStat", async (req, res) => {
const [rows, fields] = await con.promise().query(
  
  "call View_Res_Stats()"
 );
 app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
 res.render("View_Resources_Statistics",{source:rows[0]});

});
/////////////////////////////////////////////////////////////////////////////////
////////////////////////Sending HTML files///////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
app.get("/NewSignUp", async (req, res) => {
  res.sendFile(__dirname+"/NewSignUp.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

app.get("/SignUp", async (req, res) => {
res.sendFile(__dirname+"/SignUp.html");
app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
app.use('/images/', express.static('./images'));
});

//Members Homepage
app.get("/MembersHomepage", async (req, res) => {
  //const [rows, fields] = await con.promise().query(
  //  "SELECT * FROM `members`"
  //);
  //res.render("SignUp", { name: rows[0].Fname });
res.sendFile(__dirname+"/Member_Homepage.html");
app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
app.use('/images/', express.static('./images'));
});

//Member Services 
app.get("/Services", async (req, res) => {
  res.sendFile(__dirname+"/Services.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

  //Adminstration Homepage
app.get("/AdminstrationHomepage", async (req, res) => {
  res.sendFile(__dirname+"/Adminstration_Homepage.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

//Events Homepage
// app.get("/Events", async (req, res) => {
// res.sendFile(__dirname+"/Events_Homepage.html");
// app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
// app.use('/images/', express.static('./images'));
// });
//Events Homepage
app.get("/Events", async (req, res) => {
  try{
  const [rows, fields] = await con.promise().query(
    "call Get_Events;"
  );
  // console.log(rows);
  res.render('Events_Homepage',{events:rows[0]}) ;
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  }catch(e)
  {
    console.error(e)
    res.status(500).send();
  }
});

//Activities Homepage
app.get("/Activities", async (req, res) => {
  res.sendFile(__dirname+"/Activities_Homepage.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

//Member Complaints
app.get("/Complain", async (req, res) => {
  try{
  res.sendFile(__dirname+"/Member_Complaints.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  }catch(e)
  {
    console.error(e)
    res.status(500).send();
  }
  });
  //View Membership Fees
app.get("/ViewMembershipHTML", async (req, res) => {
  res.sendFile(__dirname+"/ViewMembership.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

  //Update Membership
app.get("/UpdateMembershipHTML", async (req, res) => {
  res.sendFile(__dirname+"/UpdateMembership.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

    //Joining an Event
    app.get("/JoinEvent", async (req, res) => {
      try{
      res.sendFile(__dirname+"/MembersJoinEvents.html");
      app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
      }catch(e)
      {
        console.error(e)
        res.status(500).send();
      }
      });

  //Registering into activities
  // app.get("/Register", async (req, res) => {
  //   res.sendFile(__dirname+"/Register.html");
  //   app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  //   app.use('/images/', express.static('./images'));
  //   });



  //Booking Courts
    app.get("/BookCourts", async (req, res) => {
      res.sendFile(__dirname+"/Booking_Courts.html");
      app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
      app.use('/images/', express.static('./images'));
      });
      
  // //Book Courts
  //     app.get("/BookHalls", async (req, res) => {
  //       res.sendFile(__dirname+"/Booking Hall.html");
  //       app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  //       app.use('/images/', express.static('./images'));
  //       });

//Employees Homepage
  app.get("/EmployeeHomepage", async (req, res) => {
    res.sendFile(__dirname+"/Employee_Homepage.html");
    app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
    app.use('/images/', express.static('./images'));
    });
  
//View Employee Salary
    app.get("/ViewSalary", async (req, res) => {
      res.sendFile(__dirname+"/ViewEmployeeSalary.html");
      app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
      app.use('/images/', express.static('./images'));
      }); 

//View Feedback sent to employee
app.get("/ViewFeedback", async (req, res) => {
  res.sendFile(__dirname+"/Employee_Feedback.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });     
  
//Requesting Resources
app.get("/RequestResources", async (req, res) => {
  res.sendFile(__dirname+"/Request_Resources.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });  

//Searching for a member
app.get("/SearchMember", async (req, res) => {
res.sendFile(__dirname+"/Search_Member.html");
app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
app.use('/images/', express.static('./images'));
});

//Adding a member
app.get("/AddMember", async (req, res) => {
  res.sendFile(__dirname+"/Add_Member.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

  //Delete a member
app.get("/DeleteMember", async (req, res) => {
  res.sendFile(__dirname+"/Delete_Member.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

//     //Checking Member complaints
// app.get("/AnswerComplaints", async (req, res) => {
//   res.sendFile(__dirname+"/Answer_Complaints.html");
//   app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
//   app.use('/images/', express.static('./images'));
//   });

      //Adding an event
//Adding an event
app.get("/AddEvent", async (req, res) => {
  try{res.sendFile(__dirname+"/Add_Event.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
}catch(e){
  console.error(e)
  res.status(500).send();
}
  });

        //Member Changing Password
app.get("/ChangingPassword", async (req, res) => {
  res.sendFile(__dirname+"/ChangePasswords.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

          //Member Changing Password
app.get("/AddAdmin", async (req, res) => {
  res.sendFile(__dirname+"/Add_Admin.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

            //Showing Statistics
app.get("/ShowStatistics", async (req, res) => {
  res.sendFile(__dirname+"/Showing_Statistics.html");
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  app.use('/images/', express.static('./images'));
  });

  /////////////////////View Salary Statistics For Each Department///////////
app.get("/ViewSalaryStatistics", async (req, res) => {
  const [rows, fields] = await con.promise().query(
    "call Get_Most_Paid_Dep()"
   );
   res.render('View_SalaryStatistics_Table',{Salary:rows[0]});
  app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  });

  ////////////////////////View number of Trainers For a certain Type of sports/////////////////////
  app.get("/ViewNumberOfTrainers", async (req, res) => {
    const [rows, fields] = await con.promise().query(
      "call Select_Trainer_Type()"
     );
     res.render('View_Trainers',{Trainers:rows[0]});
    
    app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
  
    });

    /////////////////////////////////View Reports//////////////////////////////////////////////////////
    app.get("/ViewReports", async (req, res) => {
      res.sendFile(__dirname+"/View_Reports.html");
      app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
      app.use('/images/', express.static('./images'));
      });
  

  //Operation Failure
  app.get("/failure", async (req, res) => {
    res.sendFile(__dirname+"/failure.html");
    app.use('/CSS', express.static(path.resolve(__dirname, "CSS")));
    app.use('/images/', express.static('./images'));
    });

app.post("/", (req, res, next) => {
  res.status(200).json({
    message: "This is a post request",

  });
});

app.listen(PORT, () => {
  console.log(`Server running on ${PORT}.`);
});
