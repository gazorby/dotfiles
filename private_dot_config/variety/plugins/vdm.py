#!/usr/bin/python
### BEGIN LICENSE
# Copyright (c) 2019, Luis GOMES
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
### END LICENSE

"""
    Variety quote plugin sourcing quotes from www.viedemerde.fr
    This script is placed in '~/.config/variety/plugins' and then activated from inside Variety's
    Preferences Quotes menu
"""

import logging
import random
import re
from locale import gettext as _
from variety.Util import Util
from variety.plugins.IQuoteSource import IQuoteSource
try:
    from urllib.request import Request, urlopen  # Python 3
except ImportError:
    from urllib2 import Request, urlopen         # Python 2
from bs4 import BeautifulSoup

logger = logging.getLogger("variety")

class VDMSource(IQuoteSource):
    """
        Retrieves quotes from www.viedemerde.fr. Reads the last quotes.
        Attributes:
            quotes(list): list containing the quotes
    """

    def __init__(self):
        self.active = False
        super(IQuoteSource, self).__init__()
        self.quotes = []

    @classmethod
    def get_info(cls):
        return {
            "name": "Vie de merde - VDM",
            "description": _("Popular quotes from www.viedemerde.fr\n"
                             "Does not support searching by tags or authors."),
            "author": "Luis Gomes",
            "url": "https://github.com/LG666/variety-vdm-quotes",
            "version": "0.0.3"
        }

    def supports_search(self):
        return False

    def activate(self):
        if self.active:
            return
        self.active = True
        self.quotes = []
        self.fetch_vdm_quotes()

    def deactivate(self):
        self.quotes = []
        self.active = False

    def is_active(self):
        return self.active

    def fetch_vdm_quotes(self):
        vdm_url = 'https://www.viedemerde.fr/rss'

        self.quotes = []

        req = Request(vdm_url)
        req.add_header('Referer', vdm_url)
        req.add_header(
            'User-Agent',
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.70 Safari/537.36'
        )
        parse_xml_url = urlopen(req)

        xml_page = parse_xml_url.read()
        parse_xml_url.close()

        soup_page = BeautifulSoup(xml_page, "xml")
        news_list = soup_page.findAll("item")

        for item in news_list:

            if item.enclosure is None:
                author = item.title.text \
                    .replace("[spicy]", "") \
                    .replace("|", " ") \
                    .strip()
                author = re.sub("^Par ", '', author + " ")
                author = re.sub("^\"|\"$", '', author)
                if author == '':
                    author = "Anonymous"
                self.quotes.append({
                    "quote": item.description.text.strip(),
                    "author": author,
                    "sourceName": "VDM",
                    "link": item.link.text.strip()})

        if not self.quotes:
            logger.warning("Could not find quotes for URL " + vdm_url)

    def get_for_author(self, author):
        return []

    def get_for_keyword(self, keyword):
        return []

    def get_random(self):
        return self.quotes

