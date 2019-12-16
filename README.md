# pinboard-bitly-import

Do something for your stored links: move them from bit.ly to pinboard https://pinboard.in/

## Disclaimer

Yes, this is written in Perl. I know that what this script does is not
reporting, much less an extraction, and Perl is not practical at all. Perl is,
however, one of my many guilty pleasures, so just deal with it despite this
being the age of Python when it comes to goddamn awful programming languages.

## Export your bit.ly links via the bit.ly API

* Open the bit.ly web app at https://app.bitly.com/
* Open the account menu -> profile -> generic access token
* Enter your password to generate a generic access token, copy it
* Get your group ID by running
```
curl -H 'Authorization: Bearer YOUR_GENERIC_ACCESS_TOKEN' https://api-ssl.bitly.com/v4/groups
```
and inspecting the ```guid``` element(s) of the received JSON
* Run
```
curl -o bitlinks.json -H 'Authorization: Bearer YOUR_GENERIC_ACCESS_TOKEN' https://api-ssl.bitly.com/v4/groups/YOUR_GROUP_ID/bitlinks?size=100000
```

## Import the exported links to pinboard

* Open the pinboard web app at https://pinboard.in/
* Navigate to settings -> password, copy your API token
* Make sure you have Date, JSON, utf8 perl modules installed
* Simply run the here supplied script, feeding it the exported links via stdin
```
perl ./bitlinks-to-pinboard.pl YOUR_PINBOARD_API_KEY <bitlinks.json
```

## Be bold

Omit the output parameter from the bit.ly exporting curl, and pipe its
output directly to the import script.
```
curl -H 'Authorization: Bearer YOUR_GENERIC_ACCESS_TOKEN' https://api-ssl.bitly.com/v4/groups/YOUR_GROUP_ID/bitlinks?size=100000 | perl ./bitlinks-to-pinboard.pl YOUR_PINBOARD_API_KEY
```
