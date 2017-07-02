# Simple server that will serve whatever it finds in the current directory
import BaseHTTPServer, SimpleHTTPServer;
s = BaseHTTPServer.HTTPServer(('', 80), SimpleHTTPServer.SimpleHTTPRequestHandler);
s.serve_forever();