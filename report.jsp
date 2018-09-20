<html>

  <head>
    <style>
      .grid-container { display: grid; grid-template-columns: auto auto; }
    </style>
  </head>

  <body>
    <div class="grid-container">
      <div>
      <button type="button" onclick="ajax ('listing.jsp?ref=report&source=report&report=shiplisting', '', 'content');">All Ships</button>
      <br><br>
      <button type="button" onclick="ajax ('listing.jsp?ref=report&source=report&report=assuredlisting', '', 'content');">All Assured</button>
      <br><br>
      <button type="button" onclick="ajax ('listing.jsp?ref=report&source=report&report=quotelisting', '', 'content');">All Quotes</button>
      <br><br>
      <button type="button" onclick="ajax ('listing.jsp?ref=report&source=report&report=policylisting', '', 'content');">All Policies</button>
      <br><br>
      <button type="button" onclick="ajax ('listing.jsp?ref=report&source=report&report=claimlisting', '', 'content');">All Claims</button>
      <br><br>
      <button type="button" onclick="ajax ('listingvendor.jsp?ref=report&source=report&report=vendorlisting', '', 'content');">All Vendors</button>
      <br><br>
      <button type="button" onclick="ajax ('d.jsp', '', 'content');">Test</button>
      <br><br>
      <form><button type="button" onclick="location.href='report-excel.jsp'">Excel example</button></form>
    </div>
    <div>
      <form><button type="button" onclick="location.href='report-claimsbordereau.jsp'">Claims Bordereau</button></form> 
    </div>
  </body>
</html>