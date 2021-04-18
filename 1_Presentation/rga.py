from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time
import pandas as pd


class RGA(object):
    
    link = 'https://www.rga.com/work'
    
    def __init__(self):
        print('Starting process...')
        # Open browser
        self.open_chrome()
        # Close 'Cookies Button'
        self.close_cookies()
        # Scroll to bottom.
        self.show_all_cases()
        print('All set!')

    def open_chrome(self):
        options = Options()
        options.headless = True
        self.driver = webdriver.Chrome(options=options)
        self.driver.get(RGA.link)
        print('Chrome ready!')
        
    def close_cookies(self):
        # Filters and Cookies
        buttons = self.driver.find_elements_by_xpath('//button[@type="button"]')
        for button in buttons:
            if button.text == 'I Agree / Close':
                button.click()
        print('Cookies Closed!')
    
    def show_all_cases(self):
        SCROLL_PAUSE_TIME = 0.5

        # Get scroll height
        last_height = self.driver.execute_script("return document.body.scrollHeight")
        print(last_height)
        while True:
            # Scroll down to bottom
            self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

            # Wait to load page
            time.sleep(SCROLL_PAUSE_TIME)

            # Calculate new scroll height and compare with last scroll height
            new_height = self.driver.execute_script("return document.body.scrollHeight")
            print(new_height)
            if new_height == last_height:
                break
            last_height = new_height

    def get_case_studies(self):
        cases = {'records':[]}
        articles = self.driver.find_elements_by_xpath('//article[@class="root___34t2D"]')
        
        id = 1
        for article in articles:
            case_study, brand = article.text.split('\n')
            cases['records'].append({'id': id, 'brand': brand, 'case': case_study})
            id += 1
        self.cases = cases
        print('All cases collected!')

    def to_csv(self):
        abs_path = '/home/robonoob/code/rga/files/'
        df = pd.json_normalize(self.cases, record_path='records')
        df.to_csv(abs_path + 'cases_airflow.csv', index=False)
        print('Cases Exported!')
