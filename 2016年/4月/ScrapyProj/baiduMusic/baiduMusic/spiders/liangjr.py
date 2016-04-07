from scrapy.spiders import Spider
from scrapy.selector import Selector

from baiduMusic.items import BaidumusicItem


class DmozSpider(Spider):
    name = "liangjr"
    allowed_domains = ["baidu.com"]
    start_urls = [
        "http://music.baidu.com/artist/1095?pst=sug",
    ]

    def parse(self, response):
        """
        The lines below is a spider contract. For more info see:
        http://doc.scrapy.org/en/latest/topics/contracts.html

        @url http://www.dmoz.org/Computers/Programming/Languages/Python/Resources/
        @scrapes name
        """
        sel = Selector(response)
        sites = sel.xpath('//span[@class="song-title "]')
        items = []
        
        for site in sites:
            item = BaidumusicItem()
            item['name'] = [t.encode('utf-8') for t in site.xpath('a/text()').extract()]
            
            items.append(item)

        return items
