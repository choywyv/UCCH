

    <div id="id01" class="modal">
      <form class="modal-content animate" name="formid01" id="formid01">
        <div class="imgcontainer">
          <span onclick="document.getElementById('id01').style.display='none'" class="close" title="Close Modal">&times;</span>
        </div>


        <div id="divid01"></div>
      </form>
    </div>

    <script id="sc4">
//document.getElementById ('id01').style.display='block';
      // Get the modal
      var modal = document.getElementById('id01');
      //https://www.w3schools.com/howto/howto_css_login_form.asp
      // When the user clicks anywhere outside of the modal, close it
      window.onclick = function(event) {
        if (event.target == modal) modal.style.display = "none";
      }

    </script>