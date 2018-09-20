
    <div id="<%= request.getParameter ("elementId") %>" class="modal">
      <form class="modal-content animate" name="form<%= request.getParameter ("elementId") %>" id="form<%= request.getParameter ("elementId") %>">
        <div class="imgcontainer">
          <span onclick="document.getElementById('<%= request.getParameter ("elementId") %>').style.display='none'" class="close" title="Close Modal">&times;</span>
        </div>

        <div class="container">
          <span style="font-weight: bold; font-size: 36px;">Search for <%= request.getParameter ("title") %></span>
          <br><br>

          <label for="Search"><b>Search</b></label>
          <input type="text" name="search" id="search" style="margin-left: 20%;">

          <input type="hidden" name="report" id="report" value="<%= request.getParameter ("report") %>">
          <input type="hidden" name="source" id="source" value="<%= request.getParameter ("source") %>">
          <input type="hidden" name="elementId" id="elementId" value="<%= request.getParameter ("elementId") %>">
          <input type="hidden" name="callerElement" id="callerElement" value="<%= request.getParameter ("callerElement") %>">
          <input type="hidden" name="callerElementId" id="callerElementId" value="<%= request.getParameter ("callerElementId") %>">


          <button type="button" onclick="reset (); document.getElementById ('div<%= request.getParameter ("elementId") %>').innerHTML = '';">Reset</button>
          <button type="button" onclick="ajax ('listing.jsp', this.form, 'div<%= request.getParameter ("elementId") %>')">Search</button>

        </div>
        <div id="div<%= request.getParameter ("elementId") %>"></div>

      </form>
    </div>

    <script id="modal-script">

      // Get the modal
      var modal = document.getElementById('<%= request.getParameter ("elementId") %>');
      //https://www.w3schools.com/howto/howto_css_login_form.asp
      // When the user clicks anywhere outside of the modal, close it
      window.onclick = function(event) {
        if (event.target == modal) modal.style.display = "none";
      }
    </script>