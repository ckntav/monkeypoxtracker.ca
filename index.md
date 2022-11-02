---
layout: single
title: How many monkeypox cases in Canada ?
classes: wide
highchart: true
---

Last update : {% include date_last_update.html %}

<div id="twitter_timeline">
	<a class="twitter-timeline" data-width="800" data-height="600" href="https://twitter.com/mkptracker_ca?ref_src=twsrc%5Etfw">Tweets by mkptracker_ca</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
</div>
<br>

<link href="/assets/css/widgetca.css" rel="stylesheet" type="text/css">
{% include widget_nb_cases_canada.html %}

<br>

{% include map_ca_mkpt.html %}

<br>

<link rel="stylesheet" href="assets/customGlyphicon/css/customGlyphicon.css">
<div class="table_var_byProvince">
	{% include table_variation_mkpt_byProvince.html %}
</div>

<br>

{% include evol_nb_cases_sum_Canada.html %}
{% include evol_nb_cases_sum_Canada_7days.html %}

<br>

{% include evol_nb_cases_sum_Canada_byProvince.html %}
{% include evol_nb_cases_sum_Canada_byProvince_7days.html %}