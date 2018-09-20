package com.efmarinegroup.servlet;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.io.output.*;

class FileUploadServlet extends HttpServlet {

  @Override  
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {  

    ServletFileUpload upload;
    FileItem fi;

    if ((request.getContentType().indexOf("multipart/form-data") >= 0)) {

      upload = new ServletFileUpload(new DiskFileItemFactory(5000 * 1024, new File("c:\\temp")));
      upload.setSizeMax(5000 * 1024);


    //Create a progress listener
    ProgressListener progressListener = new ProgressListener() {
      private long megaBytes = -1;

      public void update(long pBytesRead, long pContentLength, int pItems) {
        long mBytes = pBytesRead / 1000000;
        if (megaBytes == mBytes) return;
       
        megaBytes = mBytes;

        System.out.println("We are currently reading item " + pItems);
        System.out.println("So far, " + pBytesRead + ((pContentLength == -1) ? " bytes have been read." : " of " + pContentLength + " bytes have been read."));

      }

    };

    upload.setProgressListener(progressListener);

    for (FileItem fi : upload.parseRequest(request)) 
      if ( !fi.isFormField () )  fi.write( new File( "C:\\Program Files\\Apache Software Foundation\\Tomcat 9.0\\webapps\\test\\" + fi.getName() ) ) ;


  } // doPost

} // class