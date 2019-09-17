
function showResult( result ) {
  var html = "";
  for (var i in result.rest ){
    html +=  
       '<div class="shops-index-item">'
      + '<div class="shop-name">'
      +   `<a href="${result.rest[i].url}" target="_blank">店名${result.rest[i].name}</a>`
      + '</div>'
      +'</div>'
  }

  return html;
}

$(function(){
  
  $('#search-btn').click(function(){
    var html = "";
    var url = "https://api.gnavi.co.jp/RestSearchAPI/v3/";
    var params = {
        keyid: "6463bc55622ce5ad6df3afe4bd4d9815",
        address: $('#search').val()
    }
    $.getJSON(url, params, function(result) {
          html = showResult(result);
          $('.container').append(html);
    });
  });  
});