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

        var scriptElem, i, elems, xhttp = new XMLHttpRequest (), fData;
        if (f != "") fData = new URLSearchParams (new FormData (f));
        xhttp.onreadystatechange = function () {

          if ((this.readyState == 4 && this.status == 200) || (this.status == 404) || (this.status == 500)) { 
            document.getElementById (target).innerHTML = this.responseText;

            elems = document.querySelectorAll ("script");
            for (i = 0; i < elems.length; i++) { eval (elems[i].innerHTML); } 
//            document.querySelectorAll ("script").forEach (function (element) { eval (elemment.innerHTML); }); 
//            for (elems in document.querySelectorAll ("script")) eval (elems.innerHTML);

          }
          else document.getElementById (target).innerHTML = "Loading...Please wait..."; 

        };
        xhttp.open ("POST", loadpage, true); 
        xhttp.setRequestHeader ("Content-type", "application/x-www-form-urlencoded"); 
        xhttp.send ((f != "") ? fData : "")
      } // ajax


      ajaxPopup = function (loadpage, f, target) {

        fetch (loadpage, {
          method: 'post',
          headers: {
            'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8'
          },
          body: new URLSearchParams(f)
        }).then(function(response) { 
          response.text().then(function(text) {
            document.getElementById (target).innerHTML = text;
            document.getElementById ("id01").style.display = 'block';
            document.getElementById ("search").focus ();

            var elems = document.querySelectorAll ("script");
            for (var i = 0; i < elems.length; i++) eval (elems[i].innerHTML);

          });
        });

      } // ajaxPopup


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
        for (var i = 0; i < f.elements.length; i++) {
          f.elements [i].removeAttribute ('readonly');
          if ((f.elements [i].nodeName == "BUTTON") || (f.elements [i].nodeName == "SELECT")) f.elements [i].disabled = false;
        }
        //f.style.pointerEvents = ((f.style.pointerEvents == "") || (f.style.pointerEvents == "none")) ? "auto" : "none";

      } // formeditable


      valueInDatalist = function (datalistid, field) {
        if (document.getElementById (field).value != "") {
          var i, arr = [], a = document.getElementById(datalistid).childNodes;
          for (i = 0; i < a.length; i++) arr.push(a[i].value);
          return (arr.includes (document.getElementById (field).value));           
        }
      } // validateDatalist


      setHelp = function (msg) {
        document.getElementById ("infodiv").innerHTML = msg;
      }  //setHelp