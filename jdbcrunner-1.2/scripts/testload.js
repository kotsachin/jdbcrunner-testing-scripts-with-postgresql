
//var jdbcUrl = "jdbc:postgresql://172.26.126.156:5432/postgres";
var jdbcUrl = "jdbc:postgresql://172.26.127.116:5432/postgres";
 var jdbcUser = "postgres_user";
 var jdbcPass = "root123";
var isLoad = true;
 var scaleFactor = 10;
 var counter = 0;

 var warmupTime = 0;
 var measurementTime = 0;
 var nAgents = 1;
 function init() {
}
     //if (++counter <= scaleFactor){
         //execute ("INSERT INTO test(id, data) VALUES ($int,$string)",counter, 'ABCDEFGHIJKLMNOPQESTUVWXYZ');
	//counter=counter+1;
//	 } 
//	else{

 function run() {
         execute("CREATE TABLE tutorial(id INTEGER,data INTEGER)");
	execute("insert into tutorial values(generate_series(1,100000),generate_series(1,100000))");
         setBreak();
     //}
 } 

function fin() {
//commit();
}
