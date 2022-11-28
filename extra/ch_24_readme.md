# Challenge 24
## My solution:
- One approach without Snowpark (just regular snowlake connector)
- One with Snowpark -- could reuse most of it, just some minor tweaks needed.

![A gif showing both approaches](../assets/ch_24.gif)

## the prompt
Week 24 – Intermediate

To celebrate the release of Snowpark for Python into GA and the release of the Streamlit integration into private preview, we’re going to do a doubled up Snowpark and Streamlit challenge!

Your challenge is to create an app that looks like the one below:
![Gif showing original app to replicate](https://frostyfriday.org/wp-content/uploads/2022/11/ff_streamlit-1.gif)
Requirements:

* You must allow the user to select between the following objects:  
  * ‘None’  
  * ‘Shares’  
  * ‘Roles’  
  * ‘Grants’  
  * ‘Users’  
  * ‘Warehouses’  
  * ‘Databases’  
  * ‘Schemas’  
  * ‘Tables’  
  * ‘Views’  
* The app should display the FF logo  
* It should display the version of Snowpark you are using  
* It should display the results of show statements as a dataframe  
* Schemas, tables, views and grants should be on the account level (i.e. not per database etc…)  

{% enddocs %}