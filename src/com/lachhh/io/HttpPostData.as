package com.lachhh.io
{
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    /**
     * Helper class to add multipart/form-data (including file attachments)
     * to a form. Compared to other solutions like UploadPostHelper by Jonathan Marston,
     * this class supports multiple attachments - and it's dual licensed under MPL and LGPL
     * so you can use it in commercial projects.
     * 
     * How to use this:
     *   1. Create an Instance of HttpPostData:
     *        var postData:HttpPostData = new HttpPostData()
     * 
     *   2. Add your parameters and file attachments
     *        postData.addParameter('foo1', 'bar1'); // POST-Field 'foo1' has value 'bar1'
     *        postData.addParameter('foo2', 'bar2'); // POST-Field 'foo2' has value 'bar2'
     *      
     *        // POST-Field 'uploadedFile1' contains someBinaryData1 (ByteArray) 
     *        // as 'application/octet-stream' with filename 'uploadedFile1'
     *        postData.addParameter('uploadedFile1', someBinaryData1);
     *   
     *        // POST-Field 'uploadedFile2' contains someBinaryData2 (ByteArray) 
     *        // as 'image/png' with filename 'image.png'
     *        postData.addParameter('uploadedFile2', someBinaryData2, 'image.png', 'image/png') 
     * 
     *   3. Close this object. This will append the ending boundary to the data which makes
     *      it impossible to add additional form data.
     *        postData.close();
     * 
     *   4. Bind this to an URLRequest
     *        var request:URLRequest = new URLRequest("http://www.example.org/someDestination/");
     *        postData.bind(postData)
     * 
     *   5. Send the request:
     *        var urlLoader:URLLoader = new URLLoader();
     *        urlLoader.load(request)  
     * 
     * @Author: Roland Tapken <dev@tmp.dau-sicher.de>
     * @License: Choose the one you like, either Mozilla Public License 1.1 or 
     *           GNU Lesser General Public License 2.1.
     */
    public class HttpPostData
    {
        public static const LINEBREAK_SHORT:int = 0x0d0a; // \r\n
        public static const DOUBLEDASH_SHORT:int = 0x2d2d; // --
        public static const BOUNDARY:String = "--" + makeBoundary(32); 
        public static const BOUNDARY_BYTES:ByteArray = stringToBytes(BOUNDARY);

        private var _data:ByteArray;        
        private var _closed:Boolean = false;
        
        public function HttpPostData()
        {
            _data = new ByteArray();
            _data.endian = Endian.BIG_ENDIAN;
        }
        
        /**
         * Returns true when this object has been closed.
         * If you try to add data to an closed object
         * an Error will be thrown. If you try to bind
         * a non-closed object to an URLRequest, an error
         * will be thrown.
         */
        public function get closed():Boolean
        {
            return _closed
        }
        
        /**
         * Finalizes the data of the session by appending
         * the closing boundary string.
         */
        public function close():void
        {
            if (!closed) {
                _data.writeBytes(BOUNDARY_BYTES);
                _data.writeShort(DOUBLEDASH_SHORT);
                _data.writeShort(LINEBREAK_SHORT);
                _closed = true;
            }
        }
        
        /**
         * Returns the content type required to send this data via http
         */
        public function get contentType():String
        {
            // Drop the first to dashes for the content type line
            return 'multipart/form-data; boundary=' + BOUNDARY.substr(2);           
        }
        
        /**
         * Returns the data of this session. Note that you have to close
         * this session first unless setting ensureClosed to true in order
         * to send this data to an http destination.
         */
        public function getData(ensureClosed:Boolean = false):ByteArray
        {
            if (ensureClosed) {
                close();
            }
            return _data;
        }
        
        /**
         * Attaches an string parameter with given name and value. 
         */
        public function addParameter(name:String, value:String):void
        {
            ensureClosed(false);
            _data.writeBytes(BOUNDARY_BYTES);
            _data.writeShort(LINEBREAK_SHORT);
            var str:String = 'Content-Disposition: form-data; name="' + name + '"';
            _data.writeBytes(stringToBytes(str))
            _data.writeShort(LINEBREAK_SHORT);
            _data.writeShort(LINEBREAK_SHORT);
            _data.writeUTFBytes(value);
            _data.writeShort(LINEBREAK_SHORT);           
        }
        
        /**
         * Adds an file attachment to the request. 'name' describes the formular's
         * fieldname of the file (like the name in <input type="file" name="...">).
         * Filename is the file's original name (same es 'name' by default') and content type
         * the file's content type.
         */
        public function addFile(name:String, data:ByteArray, filename:String = null, contentType:String = 'application/octet-stream'):void
        {
            ensureClosed(false);
            if (filename == null) {
                filename = name;
            }
            var str:String;
            _data.writeBytes(BOUNDARY_BYTES);
            _data.writeShort(LINEBREAK_SHORT);
            str = 'Content-Disposition: form-data; name="' + name + '"; filename="' + filename + '"';
            _data.writeBytes(stringToBytes(str));
            _data.writeShort(LINEBREAK_SHORT);
            _data.writeBytes(stringToBytes('Content-Type: ' + contentType));
            _data.writeShort(LINEBREAK_SHORT);
            _data.writeShort(LINEBREAK_SHORT);
            
            // Write data and closing linebreaks
            _data.writeBytes(data);
            _data.writeShort(LINEBREAK_SHORT);
            _data.writeShort(LINEBREAK_SHORT);
        }
        
        /**
         * Binds this data to an URLRequest instance by setting the required
         * content type and http method and binding the data to 'urlRequest.data'.
         * Additionally, the header 'Cache-Control: no-cache' is set.
         */
        public function bind(urlRequest:URLRequest):void
        {
            ensureClosed(true);
            urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
            urlRequest.contentType = contentType;
            urlRequest.method = URLRequestMethod.POST;
            urlRequest.data = _data;
        }
        
        /**
         * Creates an new URLRequest instance and binds this data.
         *&
        public function toUrlRequest(url:String = null):URLRequest
        {
            var urlRequest:URLRequest = new URLRequest(url);
            bind(urlRequest)
            return urlRequest;
        }
        
        /**
         * Converts a string into an byte array
         */
        private static function stringToBytes(value:String):ByteArray
        {
            var bytes:ByteArray = new ByteArray();
            var i:int;
            for (i=0; i < value.length; i++) {
                bytes.writeByte(value.charCodeAt(i));
            }
            return bytes;
        }
                
        /**
         * Throws an exception if the session's state is not as expected.
         */ 
        private function ensureClosed(requiredState:Boolean):void
        {
            if (closed != requiredState) {
                if (requiredState) {
                    throw new Error("Post data has not been closed yet.");
                } else {
                    throw new Error("Post data has already been closed.");
                }
            }
        }
        
        /**
         * Generates a random boundary string as described in RFC 1341 Section 7.2
         */
        private static function makeBoundary(length:uint):String
        {
            var result:String = "";
            var chars:String = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            var index:int;
            while (length-- > 0) {
                index = Math.random() * chars.length; // int between 0 .. chars.length
                result += chars.charAt(index); 
            }
            return result;
        }
        
        
    }
}