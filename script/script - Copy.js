      menuClicked = function (obj, url) {
        setMenuActive ('mainul', obj); 
        ajax (url, '', 'content');
      } // menuClicked


      setMenuActive = function (ulobj, obj) { 

        var i, x;
        x = document.querySelectorAll(".active");
        for (i = 0; i < x.length; i++) {
          x [i].className = "inactive";
        }
    
        x = document.querySelectorAll(".inactive");
        for (i = 0; i < x.length; i++) if (x [i].id == obj.id) {
          x [i].className = "active"; 
          if (x [i].parentNode.className.includes ("subs")) 
            if (x [i].parentNode.parentNode.parentNode.nodeName != "DIV") document.getElementById (x [i].parentNode.parentNode.previousSibling.previousSibling.id).className = "active";        

        }
    
        if (window.matchMedia("(max-width: 600px)").matches) mobileNav ();
      } // setMenuActive


      setDivActive = function (tagclass, divid) {

        for (var i = 0; i < document.getElementsByClassName (tagclass).length; i++) 
          document.getElementById (document.getElementsByClassName (tagclass)[i].id).style.display = 
            (document.getElementsByClassName (tagclass)[i].id == divid) ? "block" : "none"; 
 
      } // setDivActive

 
      ajax = function (loadpage, f, target) {
        
        var i, elems, xhttp = new XMLHttpRequest ();
        xhttp.onreadystatechange = function () {

          if ((this.readyState == 4 && this.status == 200) || (this.status == 404) || (this.status == 500)) { 
            document.getElementById (target).innerHTML = this.responseText;

            elems = document.querySelectorAll ("script");
            for (i = 0; i < elems.length; i++) { eval (elems[i].innerHTML); }

          }
          else document.getElementById (target).innerHTML = "Loading...Please wait..."; 

        };
        xhttp.open ("POST", loadpage, true); 
        xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
        xhttp.send ((f != "") ? getParams (f) : "");

      } // ajax


      ajaxPopup = function (loadpage, f, target) {
        
        var xhttp = new XMLHttpRequest ();
        xhttp.onreadystatechange = function () {
          if ((this.readyState == 4 && this.status == 200) || (this.status == 404) || (this.status == 404) || (this.status == 500)) { 

            document.getElementById (target).innerHTML = this.responseText;
            document.getElementById ('id01').style.display = 'block';

            var elems = document.querySelectorAll ("script");
            for (var i = 0; i < elems.length; i++) eval (elems[i].innerHTML);

          }
          else document.getElementById (target).innerHTML = "Loading...Please wait..."; 
        };
        xhttp.open ("POST", loadpage, true); 
        xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
        xhttp.send ((f != "") ? getParams (f) : "");
      } // ajax


      getParams = function (f) {
        var kvpairs = [], i;
 
        for (i = 0; i < f.elements.length; i++ ) kvpairs.push (encodeURIComponent (f.elements [i].name) + "=" + encodeURIComponent (f.elements [i].value));
       
        return kvpairs.join ("&");
      } // getParams

      mobileNav = function () {
        var elems = document.querySelectorAll("a");

        for (var i = 0; i < elems.length; i++) {
          if (elems[i].className == "icon")  elems[i].style.display = "block";
          else if (elems[i].className == "active") elems[i].style.display = "block";
          else elems[i].style.display = (elems[i].style.display == "block") ? "none" : "block";
          //if (elems[i].className == "active") elems[i].style.display == "block";
        }  
      }

      formeditable = function (f) {
        f.style.pointerEvents = ((f.style.pointerEvents == "") || (f.style.pointerEvents == "none")) ? "auto" : "none";
      } // formeditable