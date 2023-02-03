from urllib import response
from flask import Flask, jsonify, request
import re
import time
import scrapy
from tldextract import extract
from twisted.internet import defer
from crochet import setup, TimeoutError
from scrapy.crawler import CrawlerRunner
from scrapy.utils.log import configure_logging

#-----------------------------------{Imports - End}----------------------------------------/
setup()
details = []
all_links = []
google_link = []

#-----------------------------------{Global Variables - End}----------------------------------------/


def image(response, p):
        # pattern = r'(((http:\/\/)|(http:\/\/)|)[-a-zA-Z0-9@:%_\+.~#?&//=]+)\.(jpg|jpeg|gif|png|bmp|tiff|tga|svg)'
    pattern2 = r'((https:\/\/onemg.gumlet.io\/|\/v)[-a-zA-Z0-9@:%_\+.~#?&//=]+)\.(jpg|jpeg)'
    pattern1 = r'((https:\/\/onemg.gumlet.io\/image\/upload\/l_watermark_346,w_480,h_480\/a_ignore,w_480,h_480,c_fit,q_auto,f_auto\/v\/|\/cropped)[-a-zA-Z0-9@:%_\+.~#?&//=]+)\.(jpg|jpeg)'
    script = str(response.css('script::text').extract())
    if p == 1:
        final = re.findall(pattern=pattern1,string=script)
    else: 
        final = re.findall(pattern=pattern2,string=script)
    ls = []
    res = []
    [ls.append(x) for x in final if x not in ls]
    for i in range(0,len(ls)):
        res.append(ls[i][0])
    # print("This is res Of 0 : ",res[0])
    return res


#-----------------------------------{Image Pattern - End}----------------------------------------/
def img_pattern2(response):
    # print("In Second pattern:::::::")
    new_list = []
    list_image_temp = image(response=response,p=2)
    # print(list_image_temp)
    for i in list_image_temp:
        if "/v" in i and "marketing" not in i and i.count('/') <= 2:
            new_list.append(i)
    return new_list


#-----------------------------------{Image Pattern2 - End}----------------------------------------/



def mg_drug(response):
    name = response.css('.DrugHeader__title-content___2ZaPo::text').extract_first()
    images = image(response=response,p=1)
    if len(images) == 0:
        images = img_pattern2(response=response)
    mrp1 = str(response.css('.PriceBoxPlanOption__offer-price-cp___2QPU_::text').extract_first())
    mrp2 = str(response.css('.DrugPriceBox__best-price___32JXw.selectorgadget_selected::text').extract_first())
    intro = str(response.css('#overview .DrugOverview__content___22ZBX::text').extract_first())
    manufacturer = str(response.css('.DrugHeader__meta-value___vqYM0 > a::text').extract_first())
    composition = str(response.css('.saltInfo.DrugHeader__meta-value___vqYM0 > a::text').extract_first())
    uses_and_benifits = response.css('#uses_and_benefits .DrugPane__content___3-yrB').css('::text').extract()         #list
    side_effects = response.css('#side_effects .DrugPane__content___3-yrB').css('::text').extract()                   #list
    how_to_use = str(response.css('#how_to_use .DrugOverview__content___22ZBX').css('::text').extract_first())
    how_it_works = str(response.css('#how_drug_works .DrugOverview__content___22ZBX').css('::text').extract_first())
    safty_advice = response.css('#safety_advice .DrugOverview__content___22ZBX').css('::text').extract()              #list
    missed_dose = str(response.css('#missed_dose .DrugOverview__content___22ZBX').css('::text').extract_first())
    quick_tips = response.css('.ExpertAdviceItem__content___1Djk2').css('::text').extract()                           #list
    faqs = response.css('#faq .DrugPane__content___3-yrB').css('::text').extract()
    details.append({
        'name' : name,
        'mrp1' : mrp1,
        'mrp2' :mrp2,
        'image' : images,
        'intro' : intro,
        'manufacturer' : manufacturer,
        'composition' : composition,
        'uses' : uses_and_benifits,
        'side_effects' : side_effects,
        'how_to_use' : how_to_use,
        'how_it_works' : how_it_works,
        'safty_advice' : safty_advice,
        'missed_dose' : missed_dose,
        'quick_tips' : quick_tips,
        'faqs' : faqs
    })

#-----------------------------------{DrugLinks Fetch - End}----------------------------------------/
def mg_otc(response):
    name = str(response.css('.ProductTitle__product-title___3QMYH::text').extract_first())
    images = response.css('.Thumbnail__thumbnail-image-new___3rsF_::attr(src)').extract()
    mrp1 = response.css('.PriceBoxPlanOption__offer-price-cp___2QPU_').css('::text').extract()
    mrp2 = str(response.css('.DrugPriceBox__best-price___32JXw.selectorgadget_selected').css('::text').extract())
    manufacturer = str(response.css('.ProductTitle__manufacturer___sTfon a').css('::text').extract_first())
    product_highlight = response.css('.ProductHighlights__product-highlights___2jAF5').css('::text').extract()
    product_information = response.css('.ProductDescription__description-content___A_qCZ').css('::text').extract()
    details.append({
        'name' : name,
        'mrp1' : mrp1,
        'mrp2' :mrp2,
        'image' : images,
        'product_information' : product_information,
        'manufacturer' : manufacturer,
        'product_highlight' : product_highlight,
    })
# ------------------------------------(not_found)--------------------------------------------------/
def fetch_failed(response):
    not_found = str(response.css('.BNeawe.tAd8D.AP7Wnd').css('::text').extract())
    details.append({
        'error': not_found,
    })
# -------------------------------------(not found)--------------------------------------------------/
#-----------------------------------{OTCLinks Fetch - End}----------------------------------------/
def get_links(response):
    links = response.css('.egMi0.kCrYT > a').css("::attr(href)").extract()
    for link in links:
        if ("www.1mg.com/drugs" in link or "www.1mg.com/otc" in link) and "/reviews" not in link:
            found_and = link.find('&')
            found_http = link.find('https')
            new_str = ""
            for i in range(found_http,found_and):
                new_str += link[i]
            all_links.append(new_str)
    if len(all_links) == 0:
        all_links.append('https://www.google.com/search?q=fgdsfgsdf+site:1mg.com&gbv=1&sei=FFM0Ys6xIKze2roP_MqnkAw')


#-----------------------------------{GoogleSearch Fetch - End}----------------------------------------/

class DetailsSpider(scrapy.Spider):
    name = 'get_details'
    start_urls = all_links
    custom_settings = {
      'ROBOTSTXT_OBEY':'False',
      'USER_AGENT': 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
    }
    def parse(self, response):
        if "fgdsfgsdf" in response.url:
            fetch_failed(response=response)
        elif "/drugs" in response.url:
            mg_drug(response=response)
        elif "/otc" in response.url:
            mg_otc(response=response)


#-----------------------------------{DetailsSpider - End}----------------------------------------/

#-----------------------------------{Web App - Start}--------------------------------------------------------------------------------------/
app = Flask(__name__)
@app.route("/api",methods=['GET'])
def hello():
  details.clear()
  all_links.clear()
  google_link.clear()
  query = str(request.args['Query'])


#-----------------------------------{innitial Spider(LinksSpider) - Start}----------------------------------------/
  google_link.append('https://www.google.com/search?q='+query+'+site:1mg.com&gbv=1&sei=FFM0Ys6xIKze2roP_MqnkAw')
  class LinksSpider(scrapy.Spider):
    name = 'get_links'
    custom_settings = {
      'ROBOTSTXT_OBEY':'False',
      'USER_AGENT': 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
    }
    start_urls = google_link
    def parse(self, response):
        details.clear
        get_links(response=response)
        yield {'all': all_links}
#-----------------------------------{innitial Spider(LinksSpider) - End}----------------------------------------/

#-----------------------------------{Spiders - Start}----------------------------------------/
  configure_logging()
  runner = CrawlerRunner()
  @defer.inlineCallbacks
  def crawl():
      yield runner.crawl(LinksSpider)
      yield runner.crawl(DetailsSpider)
      # reactor.stop()
  crawl()
# reactor.run()
  ln = len(details)
  while ln == 0:
    time.sleep(2)
    ln = len(details)
#-----------------------------------{Spiders - End}------------------------------------------/

  return jsonify(details)
#-----------------------------------{Web App - End}------------------------------------------------------------------------/



if __name__ == "__main__":
  app.run()

