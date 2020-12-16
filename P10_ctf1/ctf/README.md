# Micro-CMS v2

+ writing a ' in the username field of the login page results in an error that reveals _exactly_ what query is about to be executed, plus what DBMS is running on this server.
  + `sqlmap -u '...' --data='username=a&password=1' --dbms=mysql --dump`
    gives everything we need.
  + `admins.csv` contains

    ```
    id,password,username
    1,shanel,brynn
    ```
+ but then... since editing/creating just sends us to a login page which sends us to the flag, what else is there to access?
  + oh-ho-ho, the second hint was a real spoiler...
  + simply POSTing to /page/1/edit gave the last flag.

+ soooo... Without `sqlmap`, just typing
  `' OR 0 UNION SELECT "asdf" FROM dual; --`
  in the password field resulted in _actually_ getting logged in.

# Micro-CMS v1

## Flag 0

+ Since new pages are created from `/page/9` and up, and there only are 2 default pages, there should be something inbetween.
  + Inndeed there is, at `/page/5` – but we're hit with a `403 Forbidden`
  + But what if I... Aha! `/page/edit/5` gives the flag!

## Flag 1

+ it really _is_ quite simple
+ URL-encode some SQL injection string in a POST request to /page/edit/x
+ bingo.

Why did I not see this before?

+ I _think_ I just tried injecting the `page/id` pages before, that didn't work
+ Maybe I didn't URL-encode the injection?

## Flag 2

+ So... "Scripts don't work" – that's blatantly false. Of course `<script>` tags are escaped... variably well, but `<img src="nonexistent" OnError="alert('haha xss go brr')">` **does** work
  + and so does [the second example here](https://owasp.org/www-community/xss-filter-evasion-cheatsheet)
  + However, the title field gets properly escaped when viewing a page, the body does not, and the title becomes vulnerable in the table-of-contents.
  + Aha! Putting an `alert` thing in the title field then going to the home page gives a flag. Somehow.
  + (however... the body gets "javascript" overwritten with "javascrubbed")
  + (and closer inspection reveals that there, something replaces `script` with `scrubbed` - but not in table-of-contents)
  + Can't bypass the scrubbing in the body yet... Will that give the 2nd flag?

+ Is replacing `script` with `scrubbed` all that is done?

Header attempts:

A simple `<script>alert(42)</script>` is enough. There is _no_ protection here.

Body attempts:

```js
<div id="thiss">
<button onclick="let a=document.createElement('scr'+'ipt'); document.getElementById('thiss').appendChild(a)">click me</button>
</div>
```

→ it works, but does _not_ trigger the flag...

## Flag 3

+ simply adding an `onclick` to a `button` tag...
+ this feels rather specific
+ and the flag appears as an attribute in the button tag :(

# Postbook

+ substituting to `user_id=1` gave a flag
+ viewing a post then modifying to another post id gave a flag

# Magical Image Gallery

> "What does the query look like?"

```mysql
SELECT filename FROM photos WHERE id='%'
```

+ `sqlmap` did flag nr. 1 for me, the `id` parameter was injectable.
  + the flag _was_ the third image
