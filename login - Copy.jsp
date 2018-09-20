<!DOCTYPE html>
<html>

  <head>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title></title>
    <style>
      html { margin: 0; height: 100%; font-family: 'Arial'; }
      body { margin: 0; height: 100%; font-family: 'Arial'; display: grid; grid-template-rows: auto; justify-items: center; align-items: center; background-size: cover; background-position: center; background-image: url("image/background.jpg"); background-repeat: no-repeat; }
      input, button { font-size: 20px; margin-bottom: 10px; border-radius: 5px;} 
      .container { grid-column-start: 1;  background: rgb(230, 230, 230); border-radius: 10px; padding: 1em; }
    </style>

    <script>
      var timeoutCounter = setInterval (countdownTimer, 1000), timer, minutes, seconds;

      timer = <%= session.getMaxInactiveInterval () %>;

      function countdownTimer () {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        //document.getElementById ("countdown").innerHTML = minutes + ":" + seconds;
        timer--;
        if (timer < 0) {
          //document.getElementById ("countdown").innerHTML = "Page timeout! Please reload the page!";
          location.reload ();
          timedOut ();
        }
      }

      function timedOut () {
        clearInterval (timeoutCounter);
      }

    </script>

  </head>

  <body onload="document.getElementById ('j_username').focus (); timeoutCounter (); ">

    <div style="text-align: center;">

      <div class="container" style="text-align: center;">

      <h2>Login to UW/CH</h2> <span id="countdown"></span>

        <form name="loginForm" method="POST" action="j_security_check"><br>
          <input type="text" name="j_username" id="j_username" size="20" placeholder="Username"><br>
          <input type="password" size="20" name="j_password" placeholder="Password"><br>
          <button type="submit" style="padding: 0px 80px; ">Submit</button>
        </form>
      </div>
    </div>       

    <%= ((request.getHeader ("referer") != null) && (request.getHeader ("referer").equals ("https://localhost:8443/test/"))) ? "<script>window.location.href=\"/test/redirect.jsp\"</script>" : "" %>

  </body>
</html> 