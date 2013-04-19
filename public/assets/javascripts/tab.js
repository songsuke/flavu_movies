function display(sID) {

	oObj = document.getElementById(sID);
	if (oObj) {
		oObj.style.display='inline';
	}
}

function hide(sID) {
	oObj = document.getElementById(sID);
	if (oObj) {
		oObj.style.display='none';
	}
}

function gettab(id){


	for (i=1;i<=3;i++)
	{
		if (id == i)
		{
			display("box_content"+i);
      		document.getElementById("li"+i).className ='ui-state-active';
		}else{
			hide("box_content"+i);
      		document.getElementById("li"+i).className ='';
		}
	}

}

function clicktab(id){

	for (i=1;i<=3;i++)
	{
		if (id == i)
		{
			display("box_content"+i);
      		document.getElementById("li"+i).className ='ui-state-active';
		}else{
			hide("box_content"+i);
      		document.getElementById("li"+i).className ='';
		}
	}

	stoper();
	timer = setTimeout("rotate("+id+","+1000+")", 5000);
}

function stoper() {
	clearTimeout(timer);
}


function rotate(id,settime){
	if (id >3){id=1;}
		gettab(id);
		id++;
		timer = setTimeout("rotate("+id+","+settime+")", settime);

}