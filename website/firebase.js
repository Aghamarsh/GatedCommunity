
var database = firebase.database();
var m=[]
var ref = database.ref('infinity').child('users');

var table = document.createElement('table');
table.classList.add("table100");
table.classList.add("ver5");
table.classList.add("m-b-110");

ref.on('value',get,errdata);

function get(data)
{
	var x=data.val();
	var c=Object.keys(x).length;
	generatelist(c)
}



function errdata(err){

}	
s=0;
function generatelist(y)
{
for(i=0;i<y;i++){
if(s<=9)
{
  var x = s.toString();
  retrivedata("0"+x);
  }
    else
{  var x=s.toString();

	retrivedata(x);
}
s++;
}
}
function retrivedata(nameofchild){
    
	ref.child(nameofchild).on('value',gotdata,errdata);

	function gotdata(data)
	{   
		var x =  data.val();
	
		
		if(x.isAccepted == false)
		{
			createrow(x,nameofchild)
		}
	}
	
  

  function createrow(user,nameofchild){
	
	var Table = document.getElementById("tab");
	var row = Table.insertRow();

	var r0=row.insertCell(0);
	var r1=row.insertCell(1);
	var r2=row.insertCell(2);
	var r3=row.insertCell(3);
	var r4=row.insertCell(4);

	r0.innerText = user.name.toString();
	r1.innerText = user.Block.toString();
	r2.innerHTML = "Accept";
	r3.innerText = "Reject";
	r4.innerText = user.isAccepted.toString();


	row.classList.add("row100");
	row.classList.add("row101");
	m.push(nameofchild);
  }

}
function updat()
{   
   var i=document.querySelector("#Name").value;
   i--;
	var k = database.ref('infinity/users/'+ m[i]);
	k.update({isAccepted:true});
	window.location.reload();
}
function rejec()
{   
   var i=document.querySelector("#Name").value;
   i--;
	var k = database.ref('infinity/users/'+ m[i]);
	k.update({isAccepted:"rejected"});
	window.location.reload();
}
