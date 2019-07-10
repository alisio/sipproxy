<script language="JavaScript">

function pausecomp(millis)
{
var date = new Date();
var curDate = null;

do { curDate = new Date(); }
while(curDate-date < millis);
}


  
function confirmDelete(id)
{
 var agree=confirm("Are you sure you want to delete Gateway #"+id+" ?");
 if (agree)	return true;
  else return false;
}

function confirmEnable(gwid)
{
	var agree=confirm("Are you sure you want to enable Gateway #"+gwid+" ?");
	
	if (agree) 
		return true;
	else 
  		return false;
}

function confirmDisable(gwid)
{
    var agree=confirm("Are you sure you want to disable Gateway #"+gwid+" ?");

    if (agree)
        return true;
    else
        return false;
}

function confirmStateChange(gwid,state){
	if (state == "yes")
		msg = "Are you sure you want to change the state of gateway "+gwid+" to 'Inactive' ?";
	else if (state == "no")
		msg = "Are you sure you want to change the state of gateway "+gwid+" to 'Active' ?";
	
	var agree=confirm(msg);
	if (agree) 
		return true;
	else 
		return false;
}

function handleHttpResponse(http) {   
		
        if (http.readyState == 4) {
              if(http.status==200) {
                  ok = true;
				  //return results;
              }
			  
	}
		
}
       
 

function getHTTPObject() {
  	
  var request = false;
   try {
     request = new XMLHttpRequest();
   } catch (trymicrosoft) {
     try {
       request = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (othermicrosoft) {
       try {
         request = new ActiveXObject("Microsoft.XMLHTTP");
       } catch (failed) {
         request = false;
       }  
     }
   }

   if (!request)
     alert("Error initializing XMLHttpRequest!");

  
  return request;

 
}


function centerMe(element) {
//pass element name to be centered on screen
	var pWidth = window.innerWidth;
	var pTop =  window.scrollTop;
	var eWidth = document.getElementById(element).style.width
	var height = document.getElementById(element).style.height
	document.getElementById(element).style.top = '250px';
	//$(element).css('top',pTop+100+'px')
	document.getElementById(element).style.left = parseInt((pWidth / 2) - 205) + 'px';
}



function closeDialog() {
	document.getElementById('overlay').style.display = 'none';
	document.getElementById('dialog').style.display = 'none';
	document.getElementById('dialog').innerHTML = '';
}

function apply_changes(){
		url = "apply_changes.php";
		
		var http = getHTTPObject();
		
		http.open("GET", url, false);
		http.onreadystatechange = handleHttpResponse(http);
		http.send(null);
		result = http.responseText;
		
		var body = document.body,
    	html = document.documentElement;

		var height = Math.max( body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight );


		document.getElementById('overlay').style.height = height;
		document.getElementById('overlay').style.display = 'block';
		document.getElementById('dialog').innerHTML = result;
		centerMe('dialog')
		document.getElementById('overlay').onclick = function () {closeDialog();};
		document.getElementById('dialog').style.display = 'block';
		return true;
		

		document.getElementById("content").innerHTML = "whatever";
		
		
	return true;
}
</script>