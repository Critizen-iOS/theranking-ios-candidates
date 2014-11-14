#!/usr/bin/env python
"""
Simple http server to prototype API.

Based on foursquere mock server.
"""

import logging
import os
import re
import shutil
import sys
import urlparse

import SimpleHTTPServer
import BaseHTTPServer


class RequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
	"""Handle playfoursquare.com requests, for testing."""

	def do_GET(self):
		logging.info('do_GET: %s, %s', self.command, self.path)

		url = urlparse.urlparse(self.path)
		logging.info('do_GET: %s', url)
		query = urlparse.parse_qs(url.query)
		query_keys = [pair[0] for pair in query]

		response = self.handle_url(url, self.path)
		if response != None:
			self.send_200()
			shutil.copyfileobj(response, self.wfile)
		self.wfile.close()

	do_POST = do_GET


	def handle_url(self, url, full_url):
		path = os.path.join("fake-server-data", os.path.basename(url.path[1:]))
		if os.path.isfile(path):
			logging.info('Using: %s' % path)
			return open(path)

		if "search.json" in url.path:
			if "size=260" in full_url:
				path = os.path.join("fake-server-data", "search_page1.json")
				assert os.path.isfile(path), "No static file?"
				logging.info("Using %r", path)
				return open(path)
			else:
				path = os.path.join("fake-server-data", "search.json")
				assert os.path.isfile(path), "No static file?"
				logging.info("Using %r", path)
				return open(path)

		#if "categories.json" == url.path:
		#	path = os.path.join(
		#elif url.path == '/history/12345.rss':
		#	path = '../captures/api/v1/feed.xml'

		self.send_error(404)


	def send_200(self):
		self.send_response(200)
		self.send_header('Content-type', 'text/json')
		self.end_headers()


def main():
	if len(sys.argv) > 1:
		port = int(sys.argv[1])
	else:
		port = 8080
	server_address = ('0.0.0.0', port)
	httpd = BaseHTTPServer.HTTPServer(server_address, RequestHandler)

	sa = httpd.socket.getsockname()
	print "Serving HTTP on", sa[0], "port", sa[1], "..."
	httpd.serve_forever()

if __name__ == '__main__':
	logging.basicConfig(level = logging.INFO)
	main()

# vim:tabstop=4 shiftwidth=4 syntax=python
