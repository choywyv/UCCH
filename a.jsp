

<!DOCTYPE html>
<html>
  <head>
    <script>

      ajax = function (d) {

        fetch ('b.jsp', {
          method: 'post',
          headers: {
            'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
          },
          body: new URLSearchParams(new FormData (document.getElementById ('form1')))
        }).then(function(response) { 
          response.text().then(function(text) {
            document.getElementById (d).innerHTML = text;
          });
        });


      }

    </script>

    <style>
      .div1 {width:400px; height: 100px; display: none; border: 1px black solid; background: lightgrey; }      
    </style>
  </head>

  <body>

    <form name="form1" id="form1">
      <input type="text" name="text1" id="text1" value="sometext">
    </form>

    <button type="button" onclick="ajax ('div1');">Click</button>

    <div id="div1"></div>

    

  </body>
</html>