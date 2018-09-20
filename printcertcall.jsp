<%@page import = "java.io.*, java.net.*, javax.net.ssl.*, java.security.cert.*" %>

<%@include file="/dbhelper.jsp" %>

<%!

  HttpsURLConnection conn;
  BufferedReader br;
  String s;
  int i;

  void disableSslCheck () throws Exception {
    TrustManager[] trustAllCerts = new TrustManager[] {
      new X509TrustManager() {
        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
          return null;
        }
        public void checkClientTrusted(X509Certificate[] certs, String authType) { }
        public void checkServerTrusted(X509Certificate[] certs, String authType) { }
      }
    };
 
    // Install the all-trusting trust manager
    SSLContext sc = SSLContext.getInstance("SSL");
    sc.init(null, trustAllCerts, new java.security.SecureRandom());
    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
 
    // Create all-trusting host name verifier
    HostnameVerifier allHostsValid = new HostnameVerifier() {
      public boolean verify(String hostname, SSLSession session) {
        return true;
      }

    };

    HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

  }


  String getJSESSIONID (Cookie [] cookieList) throws Exception {
    String jsessid;

    jsessid = "";
    if (cookieList != null) for (Cookie cookie : cookieList) { 
      if (cookie.getName ().equals ("JSESSIONID")) {
        jsessid = cookie.getValue ();
        break;
      }
    }

    return jsessid;

  } // getJSESSIONID
  
%>

<%
  
  disableSslCheck ();

  conn = (HttpsURLConnection) new URL("https://localhost:8443/test/printcertificate.jsp?PolicyNum=efm-6004").openConnection();
  conn.setRequestProperty ("Cookie", "JSESSIONID=" + getJSESSIONID (request.getCookies()));
  conn.setDoOutput(true);
  conn.connect();
  
  br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
  for (i = 1; (s = br.readLine ()) != null; ) {
    
    if (s.length () > 0) {
      out.println (s + "\n");
      i++;
    }
  }
    
  conn.disconnect ();

  out.println (i + "<br><br>");

%>