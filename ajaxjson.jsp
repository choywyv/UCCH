
<!DOCTYPE html>
<html>
<head>
  <script>
      ajaxPopulateData = function (url, populateData) {
        var xhttp = new XMLHttpRequest ();
        xhttp.onreadystatechange = function () {
          if ((this.readyState == 4 && this.status == 200) || (this.status == 404) || (this.status == 500)) { 
            populateData (JSON.parse(xhttp.responseText));
          }
        };
        xhttp.open ("POST", url, true); 
        xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
        xhttp.send ();
      }


      populateData = function (obj) {
        var i;
        for (i = 0; i < Object.keys (obj).length; i++) document.getElementById (Object.keys (obj) [i]).innerHTML = obj [Object.keys (obj)[i]];
      } 

  </script>
</head>

<body <%= ("if quotenum is not null".equals ("")) ? "onLoad=\"ajaxPopulateData ('getJSON.jsp', populateData);\" : "" %>>
  <form name="form1">
    <div id="a"></div>
    <div id="b"></div>
    <div id="c"></div>
<div id="QuoteNum"></div>
  </form>


  </body>
</html>