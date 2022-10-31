  {% set whs = [{'name':'wh_xs','size':'XSMALL'},{'name':'wh_s','size':'SMALL'}] %}
  {% if execute %}
{{ log('here',info=True)}}
  {% for item in whs %}
    {{ item['name'] }} is a wh of size {{ item['size'] }}

{% endfor %}

{% endif %}