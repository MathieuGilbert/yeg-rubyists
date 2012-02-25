function FormatUtcDate (uglyDate) {
  // ex: 2012-02-22 00:02:28.0000000 (in UTC)
  // to: Feb 22 2012 02:28 (adjust for user's timezone)
  
  var date = new Date(uglyDate);
  
  // adjust for user's time zone
  var timeZone = new Date().getTimezoneOffset() / 60;
  date.setHours(date.getHours() - timeZone);

  return date.toString().substring(4, 21);
}

function ShowLinks(parent) {
  var links = parent.querySelector(".memberLinks");

  if (links.style.display == 'block') {
    // close it
    links.style.display = 'none';
  } else {
    // show it
    links.style.display = 'block';
  }
}