//var jdbcUrl = "jdbc:postgresql://localhost:5432/postgres";
//var jdbcUrl = "jdbc:postgresql://172.26.127.126:5432/postgres";
var jdbcUrl = "jdbc:postgresql://172.26.127.116:5432/postgres";
 var jdbcUser = "postgres_user";
 var jdbcPass = "root123";
 var warmupTime = 20;
 var measurementTime = 60;
 var nAgents = 4;
 var isAutoCommit = false;
 var isDebug = true; 
 var logDir = "logs";


 var emp;

 function init () {
     if (getId () == 0) {
         putData ("emp", fetchAsArray ("SELECT * FROM tutorial ORDER BY id"));
     }
 }

 function run () {
     if (! emp) {
         emp = getData ("emp");
     }

     var empno = emp [random (0, emp.length - 1)] [0];
     query ("SELECT data FROM tutorial WHERE id = $int", empno);
 } 
