# link_fragment_tester
`link_fragment_tester` is a BASH script for finding and evaluating "link fragments" (the part after the # in a URL) present in local HTML files (before they are published to the web).

---

I've been building my website (<a href="https://buriedtruth.com/"><b>BuriedTruth.com</b></a> -- adding content (HTML files) into a documents (`docs`) folder and (for now) linking them to a <a href="https://buriedtruth.com/index.html">BuriedTruth.com/index.html</a> page.

I've been careful to minimize errors, such as malformed / broken URLs (checked using <a href="https://github.com/linkchecker/linkchecker/issues/519">`linkchecker`</a>).

I also use a lot of "link fragments" -- the part after `#` in URLs -- for intra- and inter-document text linking.  It turns out this issue manifests client side and appears to be a challenging issue ... so there are limited available tools for finding and correcting link fragment errors.

Accordingly, I wrote a BASH script to scan files in my `docs` directory, and my `index.html` file.

Since these files are all local, finding the errors and correcting them is relatively trivial.

```bash
[victoria@victoria 1.0]$ dp; tree -L 1 -F . | egrep -i 'index|\bdocs\b|\bfiles\b'

    Wed Oct 21 03:56:16 PM PDT 2020
    /mnt/Vancouver/domains/buriedtruth.com/1.0

    ├── docs/
    ├── files/
    ├── files-unused/
    ├── index.html
    8 directories, 9 files

[victoria@victoria 1.0]$ 
```

The corrected files are then pushed (`rsync`) online, to my ISP / website.  :-D

As always, see my script for details / comments.

You'll have to make some edits to that script for your use, but hopefully those edits will be clear, upon studying the code.

**Data summary**

```bash
[victoria@victoria docs]$ ls | wc -l ; cat * | wc -c; echo; ls | head -n5 ; echo; ls | tail -n5  ## wc -l : no. of files; wc -m : no. of char

    2135       ## 2,135 files, containing (in aggregate)
    53098515   ## 53,098,515 characters (bytes, essentially)

    1033_program.html
    11-million-dollar-question-for-tides-canada.html
    140-million-females-missing-due-son-preference.html
    16-batshit-crazy-moments-from-john-boltons-book-about-trump.html
    1927-Fred_Trump_arrested_in_KKK brawl_with_cops.html

    wyss_foundation.html
    you-cant-do-that-betsy-devos-gets-schooled-by-fox-news-host.html
    your-online-activity-effectively-social-credit-score-airbnb.html
    zuckerberg_says_facebooks_goal_is_no_longer_to_be_liked.html
    zuckerberg_says_facebooks_new_approach_will_piss_off_a_lot_of_people.html

[victoria@victoria docs]$ du -h /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/
    56M	/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/V
```

**Sample output** (with my "post-script" corrections manually added, here)

```bash
victoria@victoria docs]$ cat /mnt/Vancouver/domains/buriedtruth.com/1.0/link_fragment_errors.txt

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Acton_Institute.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#exxonmobile
    ## correction: exxonmobil

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/coastal-gas-link-rail-blockades-facebook.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#manning_centre
    ## correction: canada_strong_and_free_network [Manning Centre was renamed as such ...]

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Competitive_Enterprise_Institute.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#libertarian>
    ## correction: removed errant > at end of libertarian

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/donald-j-trump-deep-state.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#<b>Donors
    ## correction: mangled URL#link fragment -- added correct "koch_family" link fragment

[ ... snip ... ]
```

The beauty and joy of editing those files in Vim is that I can open the results file [`/mnt/Vancouver/domains/buriedtruth.com/1.0/link_fragment_errors.txt`] in Vim,

```
    ...
    FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Lincoln_Network.html
    URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#Knight
    ...
```

and

  * open the FILE in the browser (Firefox) using `gx` when positioned on the link;
  * open the URL in Vim for editing using `gf` when positioned on the link;
  * search for and correct the non-functioning link fragment, then reload the web page to verify the edit / correction

In Vim, I use the <a href="https://github.com/jlanzarotta/bufexplorer">BufExplorer</font></a> plugin, mapped (~/.vimrc) to `<space><space>` [I use the spacebar is my `<Leader/>`], to quickly / effortlessly navigate between Vim buffers.

---

**SAMPLE OUTPUT: TEST DIRECTORY**

    lft: link_fragment_tester.sh

cnp_* file found; skipping

----------------------------------------
FILE: 1 | NAME: linkchecker-test_file1.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html

 RAW LINE: #bookmark1
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html#bookmark1
     LINK: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html
 FRAGMENT: bookmark1
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html#bookmark2
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html#bookmark2
     LINK: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html
 FRAGMENT: bookmark2
   STATUS: OK

 RAW LINE: #bookmark9
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html#bookmark9
     LINK: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html
 FRAGMENT: bookmark9
   STATUS: MISSING
		FILE: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html
		 URL: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html#bookmark9

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html#bookmark9
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html#bookmark9
     LINK: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html
 FRAGMENT: bookmark9
   STATUS: MISSING
		FILE: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html
		 URL: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html#bookmark9

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#endswell_foundation
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#endswell_foundation
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: endswell_foundation
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#makeway
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#makeway
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: makeway
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#focus_on_the_family
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#focus_on_the_family
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: focus_on_the_family
   STATUS: OK


----------------------------------------
FILE: 2 | NAME: linkchecker-test_file2.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html

------------------------------------------------------------------------------
Done!  :-D
elapsed time: 1603387787 sec | 26723129.8 min

=============================================================================
FILE:/mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html
URL:/mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html#bookmark9

FILE:/mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html
URL:/mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file2.html#bookmark9
[victoria@victoria link_fragment_tester]$ 

==============================================================================

---

**SAMPLE OUTPUT: PUBLISHED HTML FILES (EXAMINED LOCALLY)**

* While external links are checked (e.g. Wikipedia -- example below -- extensively uses link fragments and those files throw errors, since be nature we can only verify local files), the `link_fragment_tester.sh` script parses all of those "junk" lines from the output.

* The final output is `cat` to the terminal, and also to file `link_fragment_errors.txt`.

```bash
cnp_* file found; skipping

----------------------------------------

## [ ... SNIP (manually deleted here) ... ]

----------------------------------------
FILE: 2080 | NAME: whiplash-of-lgbtq-protections-and-rights-from-obama-to-trump.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/whiplash-of-lgbtq-protections-and-rights-from-obama-to-trump.html

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe-betsy_devos
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe-betsy_devos
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: transphobe-betsy_devos
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe-betsy_devos
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe-betsy_devos
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: transphobe-betsy_devos
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe_roger_severino
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe_roger_severino
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: transphobe_roger_severino
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe_roger_severino
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transphobe_roger_severino
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: transphobe_roger_severino
   STATUS: OK

 RAW LINE: https://buriedtruth.com/index.html#trump_erases_transhealth
FULL PATH: https://buriedtruth.com/index.html#trump_erases_transhealth
     LINK: https://buriedtruth.com/index.html
 FRAGMENT: trump_erases_transhealth
https://buriedtruth.com/index.html: No such file or directory (os error 2)
   STATUS: MISSING
		FILE: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/whiplash-of-lgbtq-protections-and-rights-from-obama-to-trump.html
		 URL: https://buriedtruth.com/index.html#trump_erases_transhealth

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transgender_bathroom_meme
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#transgender_bathroom_meme
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: transgender_bathroom_meme
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#heritage_foundation
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#heritage_foundation
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: heritage_foundation
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#heritage_foundation
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#heritage_foundation
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: heritage_foundation
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#supreme_court-lgbt_rights
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#supreme_court-lgbt_rights
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: supreme_court-lgbt_rights
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#heritage_foundation
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#heritage_foundation
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: heritage_foundation
   STATUS: OK

## [ ... SNIP (manually deleted here) ... ]

----------------------------------------
FILE: 2120 | NAME: William_Volker_Fund.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/William_Volker_Fund.html

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#william_volker_fund
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#william_volker_fund
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: william_volker_fund
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#libertarian
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#libertarian
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: libertarian
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#milton_friedman
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#milton_friedman
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: milton_friedman
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#mont_pelerin_society
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#mont_pelerin_society
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: mont_pelerin_society
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#floyd_arthur_harper
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#floyd_arthur_harper
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: floyd_arthur_harper
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#christian_right
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#christian_right
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: christian_right
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#intercollegiate_studies_institute
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#intercollegiate_studies_institute
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: intercollegiate_studies_institute
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#foundation_for_economic_education
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#foundation_for_economic_education
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: foundation_for_economic_education
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#earhart_foundation
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#earhart_foundation
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: earhart_foundation
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#institute_for_humane_studies
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#institute_for_humane_studies
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: institute_for_humane_studies
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#foundation_for_economic_education
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#foundation_for_economic_education
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: foundation_for_economic_education
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#hoover_institution
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#hoover_institution
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: hoover_institution
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#floyd_arthur_harper
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#floyd_arthur_harper
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: floyd_arthur_harper
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#william_volker_fund
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#william_volker_fund
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: william_volker_fund
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#institute_for_humane_studies
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#institute_for_humane_studies
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: institute_for_humane_studies
   STATUS: OK

 RAW LINE: https://en.wikipedia.org/wiki/William_Volker_Fund#Controversy_and_collapse
FULL PATH: https://en.wikipedia.org/wiki/William_Volker_Fund#Controversy_and_collapse
     LINK: https://en.wikipedia.org/wiki/William_Volker_Fund
 FRAGMENT: Controversy_and_collapse
https://en.wikipedia.org/wiki/William_Volker_Fund: No such file or directory (os error 2)
   STATUS: MISSING
		FILE: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/William_Volker_Fund.html
		 URL: https://en.wikipedia.org/wiki/William_Volker_Fund#Controversy_and_collapse

## [ ... SNIP (manually deleted here) ... ]

----------------------------------------
FILE: 2133 | NAME: you-cant-do-that-betsy-devos-gets-schooled-by-fox-news-host.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/you-cant-do-that-betsy-devos-gets-schooled-by-fox-news-host.html

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#betsy_devos-edsec
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#betsy_devos-edsec
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: betsy_devos-edsec
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#fox_news
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#fox_news
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: fox_news
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#betsy_devos-edsec
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#betsy_devos-edsec
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: betsy_devos-edsec
   STATUS: OK

 RAW LINE: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#betsy_devos-pandemic-schools
FULL PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#betsy_devos-pandemic-schools
     LINK: /mnt/Vancouver/domains/buriedtruth.com/1.0/index.html
 FRAGMENT: betsy_devos-pandemic-schools
   STATUS: OK

----------------------------------------
FILE: 2134 | NAME: your-online-activity-effectively-social-credit-score-airbnb.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/your-online-activity-effectively-social-credit-score-airbnb.html

----------------------------------------
FILE: 2135 | NAME: zuckerberg_says_facebooks_goal_is_no_longer_to_be_liked.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/zuckerberg_says_facebooks_goal_is_no_longer_to_be_liked.html

----------------------------------------
FILE: 2136 | NAME: zuckerberg_says_facebooks_new_approach_will_piss_off_a_lot_of_people.html
PATH: /mnt/Vancouver/domains/buriedtruth.com/1.0/docs/zuckerberg_says_facebooks_new_approach_will_piss_off_a_lot_of_people.html

------------------------------------------------------------------------------
Done!  :-D
elapsed time: 146 sec | 2.4 min

=============================================================================

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Acton_Institute.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#exxonmobile

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Americans_for_Tax_Reform.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Americans_for_Tax_Reform.html#climate_change_denial

## [ ... SNIP (manually deleted here) ... ]

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Tea_Party_Caucus.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Tea_Party_Caucus.html#anti-gay

FILE:/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/whiplash-of-lgbtq-protections-and-rights-from-obama-to-trump.html
URL:https://buriedtruth.com/index.html#trump_erases_transhealth

[victoria@victoria docs]$ 

```

---

```bash
$ cat /mnt/Vancouver/domains/buriedtruth.com/1.0/link_fragment_errors.txt |head

FILE:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Acton_Institute.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#exxonmobile

FILE:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Americans_for_Tax_Reform.html
URL:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Americans_for_Tax_Reform.html#climate_change_denial

FILE:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/coastal-gas-link-rail-blockades-facebook.html
URL:/mnt/Vancouver/domains/buriedtruth.com/1.0/index.html#manning_centre


$ cat /mnt/Vancouver/domains/buriedtruth.com/1.0/link_fragment_errors.txt |tail
URL:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/sources.html#cbc-vladislav_sobolev

FILE:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Tea_Party_Caucus.html
URL:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Tea_Party_Caucus.html#theocracy

FILE:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Tea_Party_Caucus.html
URL:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/Tea_Party_Caucus.html#anti-gay

FILE:/mnt/Backups/rsync_backups/daily.1/mnt/Vancouver/domains/buriedtruth.com/1.0/docs/whiplash-of-lgbtq-protections-and-rights-from-obama-to-trump.html
URL:https://buriedtruth.com/index.html#trump_erases_transhealth
```
