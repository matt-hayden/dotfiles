#! /usr/bin/env python2
from collections import Counter
from email.utils import parseaddr
import smtplib
import socket

import dns.resolver

def split_email_address(text):
	_, address = parseaddr(text)
	f = Counter(address)
	assert f['@'] == 1
	return address.split('@')
def get_exchange(domain_name, record_type='MX'):
	if not domain_name.endswith('.'): domain_name += '.'
	answers = []
	while not answers:
		try:
			answers = dns.resolver.query(domain_name, 'MX')
		except dns.resolver.NoAnswer as e:
			print domain_name, "not found:", e
			c = Counter(domain_name)
			if c['.'] <= 2:
				raise e
			_, domain_name = domain_name.split('.', 1)
	answers = sorted(answers, key=lambda rdata: rdata.preference)
	smtp_server_rdata = answers.pop()
	return str(smtp_server_rdata.exchange)
def get_email_server_connection(hostname, debuglevel=True):
	try:
		server = smtplib.SMTP(hostname)
	except socket.error as e:
		return None
	except smtplib.SMTPConnectError as e:
		return None
	if debuglevel:
		server.set_debuglevel(debuglevel)
	server.ehlo_or_helo_if_needed()
	return server
def check_email_address(text):
	label, address = parseaddr(text)
	username, domain = split_email_address(address)
	try:
		hostname = get_exchange(domain)
	except dns.resolver.NoAnswer:
		return False, 'NoAnswer'
	except dns.resolver.NXDOMAIN:
		return False, 'NXDOMAIN'
	print locals()
	server = get_email_server_connection(hostname)
	if not server:
		return (False, "server not available")
	try:
		response_code, response = server.verify(username)
	except smtplib.SMTPServerDisconnected as e:
		return (False, "server disconnected")
	if 'ok' not in response.lower() or '200' not in response or '2.0.0' not in response:
		response_code, response = server.verify(address)
	return (response_code in (250, 252), response)
#
if __name__ == '__main__':
	import sys
	
	for addr in # TODO: some iterable
		ok, response = check_email_address(addr)
		if ok:
			print "***", addr
		print "'{}':\t'{}'".format(addr, response)
		line = raw_input("Enter to continue: ")
		if 'q' in line:
			break
# EOF
