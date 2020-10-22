#!/bin/bash
# vim: set filetype=sh :
# vim: syntax=sh autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 textwidth=220
export LANG=C.UTF-8

#          file: /mnt/Vancouver/programming/scripts/link_fragment_tester.sh
#       created: 2020-10-14
#       version: 05
# last modified: 2020-10-22 11:34:58 -0700 (PST)
#     ~/.bashrc: lft
#         usage: cd to dir with html documents; execute script: lft
# 
# Versions:
#   * v01:  Extracts URLs; resolves URLs to local link fragments: <a href="#bookmark1">Go to bookmark 1</a>
#           V. difficult to process URLs (" double quotes, specifically) with sed; URLs not needed ...
#   * v02:  Extracts URLS >> link + link fragment:
#           /mnt/Vancouver/domains/buriedtruth.com/linkchecker-tests/linkchecker-test_file1.html#bookmark1
#   * v03:  Refinements (code cleaning ...); link/fragment verification code added 
#   * v04:  Renamed script (old: url_link_fragment_tester.sh); cleaned script.
#   * v05:  Cleaned script; added reference material, examples; posted to GitHub.
# =============================================================================

# ----------------------------------------------------------------------------
## NOTES

## Programmed in Vim, textwidth = 220.

## sed: linux sed command
##  rg: linux ripgrep command (you can substitute grep if you prefer, but you may have to tweak some of the arguments)

## regex refresher: https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html
## 
## regex backreferences [sed -r 's/:
##      https://www.grymoire.com/Unix/Sed.html#uh-4
##      https://www.grymoire.com/Unix/Regular.html#uh-10
##      https://www.gnu.org/software/sed/manual/html_node/Back_002dreferences-and-Subexpressions.html
## Example:
##      echo 'apples This is not correct. bananas' | sed -r 's/^.*(This is ).*(correct)\..*$/\1\2./g' >> 
## Result:
##      This is correct.

##  https://en.wikipedia.org/wiki/URI_fragment
## A "link fragment" (aka URI fragment) is the part after the # in a URL.
## The link fragment is not available on the server side:
##  When a URI reference is used to perform a retrieval action on the identified resource, the optional fragment identifier,
##  separated from the URI by a crosshatch ("#") character, consists of additional reference information to be interpreted by
##  the user agent after the retrieval action has been successfully completed. As such, it is not part of a URI, but is often
##  used in conjunction with a URI.
## Source: RFC2396: https://tools.ietf.org/html/rfc2396#section-3.5 | https://stackoverflow.com/questions/34687098/how-to-get-the-fragment-identifier-part-of-an-url
## Basically: since link fragments are interpreted locally (web browser), link checkers cannot evaluate them
## (hence the lack of existing verification tools, except possibly https://github.com/sidvishnoi/href-checker).
## However, since I produce my HTML content locally then push it to my server (ISP), I can write a script
## to check the validity of link fragments locally, before pushing those files to the web.

## Verification of URL link fragments was complicated by the shared use of characters (/ " especially) in URLs and sed expressions,
## and the need to use doubled (sets of """") to use BASH variables in linux commands, and the need to use double quotes ("sed ...)
## with sed expressions that include ""$BASH_VARIABLES"" ... :-/

<<COMMENT
    Example: scraping URLs (links; link fragments) from sentences.
    Run each of the parsing commands (sed; rg), sequentially, to see their effect.

    echo 'The over-arching question raised here is this: What is the justification for $11.4 million in overhead expenditures - including relatively high salaries - while the <a href="../index.html#endswell_foundation"><font color="green"><b>Endswell Foundation</b></font></a> was simply transferring money to <a href="../index.html#makeway"><font color="green"><b>Tides Canada</b></font></a>?</p> <li> <p><a href="National_Organization_for_Marriage.html">National_Organization_for_Marriage.html</a> (~line 342): In September 2010, the <a href="https://en.wikipedia.org/wiki/Human_Rights_Campaign">Human Rights Campaign</a> (HRC) and the <a href="https://en.wikipedia.org/wiki/Courage_Campaign">Courage Campaign</a> launched "<a href="https://www.hrc.org/press-releases/hrcs-exposure-of-secret-nom-documents-shows-dark-underbelly-of-anti-gay-mov"><b>NOM Exposed</b></a>' | sed 's/<a href/\n<a href/g' | sed -r 's/.*(<a href.*<\/a>).*/\1/g' | sed 's/></\n/g' | rg -e '^<a href' | rg -o '".*"' | sed 's/"//g'

    ../index.html#endswell_foundation
    ../index.html#makeway
    National_Organization_for_Marriage.html
    https://en.wikipedia.org/wiki/Human_Rights_Campaign
    https://en.wikipedia.org/wiki/Courage_Campaign
    https://www.hrc.org/press-releases/hrcs-exposure-of-secret-nom-documents-shows-dark-underbelly-of-anti-gay-mov
    [victoria@victoria docs]$ 
COMMENT

# ----------------------------------------------------------------------------`
## INITIALIZATIONS

i=1
rm -f /tmp/link_fragment_errors.txt
START=$(date +"%s")                                                             ## seconds since Epoch

# ----------------------------------------------------------------------------
## MAIN (LOOP)

for FILE in *
do
    rm -f /tmp/tmp_link
    ## https://linuxize.com/post/how-to-check-if-string-contains-substring-in-bash/
    if [[ "$FILE" == *"cnp_"* ]]
    then
        printf '\ncnp_* file found; skipping\n'
        continue
    fi
    printf '\n----------------------------------------\nFILE: %s | NAME: %s\n' $i $FILE
    ((i=i+1))
    # ----------------------------------------
    ## https://stackoverflow.com/questions/3915040/bash-fish-command-to-print-absolute-path-to-a-file
    FILE=$(realpath ""$FILE"")
    printf 'PATH: %s\n\n' $FILE
    # ----------------------------------------
    ## BASH variables inside commands must be ""doubled double quoted"" (use "" not ''), e.g.: TMP_URL=$(echo ""$FILE"")
    ## AND sed command itself must use double quotes " not single quotes ' , e.g.: sed -i "s,"#,"""$URL""#,g" /tmp/tmp_url
    ## BASH variables with spaces etc. must be "double-quoted" to prevent sed from splitting strings as words (use "" not '').
    # ----------------------------------------
    ## GET LINK + LINK FRAGMENT -- find lines with URLS containing link fragments, then process those URLS:
    rg ""$FILE"" -e "<a.*#"  \
        | sed 's/<a href/\n<a href/g' \
        | sed -r 's/.*(<a href.*<\/a>).*/\1/g' \
        | sed 's/></\n/g' \
        | rg -e '^<a href' \
        | rg -e "<a.*#"  \
        | rg -o '".*"' \
        | sed 's/"//g' \
        | sed 's/\.\.\/index.html/\/mnt\/Vancouver\/domains\/buriedtruth.com\/1.0\/index.html/' >> /tmp/tmp_link
    # ----------------------------------------
    ## https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
    while read LINE; do
        # ----------------------------------------
        echo " RAW LINE: $LINE"
        # ----------------------------------------
        ## URLs contain / so swap those in sed expression with ,:
        FULL_PATH=$(echo $LINE | sed "s,^#,""$FILE""#,")
        printf 'FULL PATH: %s\n' $FULL_PATH
        # ----------------------------------------
        ## LINKS:
        LINK=$(echo $FULL_PATH | sed -r 's/(.*)#.*/\1/')
        printf '     LINK: %s\n' $LINK
        # ----------------------------------------
        ## FRAGMENTS:
        FRAGMENT=$(echo $LINE | sed -r "s/.*#(.*)/\1/")
        printf ' FRAGMENT: %s\n' $FRAGMENT
        # ----------------------------------------
        if rg -e ""$FRAGMENT"" ""$LINK"" | rg -q 'id='
        then
            printf '   STATUS: OK\n\n'
        else
            # printf '   STATUS: MISSING\n\t\tFILE: %s\n\t\t URL: %s#%s\n\n' $FILE $LINK $FRAGMENT
            ## https://askubuntu.com/questions/808539/how-to-append-tee-to-a-file-in-bash
            printf '   STATUS: MISSING\n\t\tFILE: %s\n\t\t URL: %s#%s\n\n' $FILE $LINK $FRAGMENT | tee -a /tmp/link_fragment_errors.txt
        fi
    done </tmp/tmp_link
done

# ----------------------------------------------------------------------------
## SCRIPT COMPLETION

echo '------------------------------------------------------------------------------'
printf 'Done!  :-D\n'

## https://stackoverflow.com/a/20249473/1904943                                 ## "How to calculate time elapsed in bash script?"
# START=$(date +"%s")                                                           ## [at top of script] seconds since Epoch
END=$(date +"%s")                                                               ## integer
TIME=$((END-START))                                                             ## integer
MINUTES=$(python -c "print(float($TIME/60))")                                   ## int to float via Python
printf 'elapsed time: %d sec | %0.1f min\n' $TIME $MINUTES

## I'll upload (GitHub) this wav file.
for i in 1 2 3; do aplay 2>/dev/null /mnt/Vancouver/programming/scripts/PHASER.WAV && sleep 0.5; done

# ----------------------------------------------------------------------------
## RESULTS

printf '\n=============================================================================\n'

## https://kifarunix.com/delete-lines-matching-a-specific-pattern-in-a-file-using-sed/
sed -i '/STATUS: MISSING/d' /tmp/link_fragment_errors.txt

## remove white space at beginning of remaining lines:
sed -i -r 's/\s{1,}//g' /tmp/link_fragment_errors.txt

# cat /tmp/link_fragment_errors.txt

## https://sharadchhetri.com/print-grep-command-output-without-seperator/
cat /tmp/link_fragment_errors.txt | grep -i -B2 --no-group-separator 'URL:.*buriedtruth.com' > /mnt/Vancouver/domains/buriedtruth.com/1.0/link_fragment_errors.txt
cat /mnt/Vancouver/domains/buriedtruth.com/1.0/link_fragment_errors.txt

## If needed:
##   ## rg -h | grep separator
##   cat /mnt/Vancouver/domains/buriedtruth.com/1.0/link_fragment_errors.txt | rg -i -B2 --context-separator '' -e <search_term>

# ============================================================================

