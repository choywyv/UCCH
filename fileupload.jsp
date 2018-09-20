<%@ page import="java.io.*,java.util.*, javax.servlet.*, javax.servlet.http.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*, org.apache.commons.io.output.*" %>

<%!

  ServletFileUpload upload;
  FileItem fi;

%>

<html>

  <body>

<%

  if ((request.getContentType().indexOf("multipart/form-data") >= 0)) {

    upload = new ServletFileUpload(new DiskFileItemFactory(5000 * 1024, new File("c:\\temp")));
    upload.setSizeMax(5000 * 1024);

/*
    //Create a progress listener
    ProgressListener progressListener = new ProgressListener() {
      private long megaBytes = -1;

      public void update(long pBytesRead, long pContentLength, int pItems) {
        long mBytes = pBytesRead / 1000000;
        if (megaBytes == mBytes) return;
       
        megaBytes = mBytes;

        out.println("We are currently reading item " + pItems);
        out.println("So far, " + pBytesRead + ((pContentLength == -1) ? " bytes have been read." : " of " + pContentLength + " bytes have been read."));


      }

    };

    upload.setProgressListener(progressListener);
*/

    for (FileItem fi : upload.parseRequest(request)) 
      if ( !fi.isFormField () )  fi.write( new File( "C:\\Program Files\\Apache Software Foundation\\Tomcat 9.0\\webapps\\test\\" + fi.getName() ) ) ;


  }


%>

  </body>
</html>