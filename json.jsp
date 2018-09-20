<%@ page import = "java.net.*, java.io.*" %>

<%!

  String getJSON(String url) throws Exception {
    HttpURLConnection c;
    BufferedReader br;    
    String s, line;

    c = (HttpURLConnection) new URL(url).openConnection();
    c.setRequestMethod("GET");
    c.setRequestProperty("Content-length", "0");
    c.setUseCaches(false);
    c.setAllowUserInteraction(false);
//    c.setConnectTimeout(timeout);
//    c.setReadTimeout(timeout);
    c.connect();

    br = new BufferedReader(new InputStreamReader(c.getInputStream()));
    for (line = ""; (s = br.readLine()) != null; line += s);
    br.close();

     return line;
  }

%>


<!DOCTYPE html>
<html>

  <head>
    <script>

      KVToObj = function (k, v) {
        return JSON.parse ("{\"" + k + "\":\"" + v + "\"}");
      }


      getKV = function (obj) {
//        return Object.keys (obj)[i] + " : " + (isJson (obj [Object.keys (obj)[i]])) ? getKV (obj [Object.keys (obj)[i]]) : obj [Object.keys (obj)[i]];
        return Object.keys (obj) [0] + " : " + obj [Object.keys (obj)[0]];
      }

      isJson = function (item) {
        item = (typeof item !== "string") ? JSON.stringify(item) : item;
        try {
          item = JSON.parse(item);
        }
        catch (e) {
          return false;
        }

        return (typeof item === "object" && item !== null);
      }
    </script>
  </head>

  <body>

    <p id="demo"></p>


    <script>

      var i, obj = <%= getJSON ("http://search.ofac-api.com/api/v1?name=John%20Smith&minScore=70&apiKey=demo_key") %>;

      for (i = 0; i < Object.keys (obj).length; i++) document.getElementById ("demo").innerHTML += getKV (JSON.parse ("{\"" + Object.keys (obj) [i] + "\":\"" + obj [Object.keys (obj) [i]] + "\"}")) + "<br>";



//alert (obj.matches[0].entry.vesselInfo.vesselOwner);
// Object.keys (obj).forEach(function(k) {
//    document.getElementById("demo").innerHTML += (k + ' - ' + obj[k]) + "<br>";
//    document.getElementById("demo").innerHTML += (k + ' - ' + (isJson (obj[k]) ? getKV ("", obj) : obj[k]) ) + "<br>";
// });


    </script>


  </body>
</html>