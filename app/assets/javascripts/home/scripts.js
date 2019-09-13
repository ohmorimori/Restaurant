
function showResult( result ) {
  var html = "";
  console.log("hi");
  for (var i in result.rest ){
    html +=  
       '<div class="shops-index-item">'
      + '<div class="shop-name">'
      +   `<%= link_to("店名${result.rest[i].name}", ${result.rest[i].url}, target: "_blank") %>`
      + '</div>'
      +'</div>'
  }
  return html;
}

$(function(){
  console.log("hi");
  //値取れない
  var html = "";
  $('#search-btn').click(function(){
    
    var url = "https://api.gnavi.co.jp/RestSearchAPI/v3/";
    var params = {
        keyid: "6463bc55622ce5ad6df3afe4bd4d9815",
        format: "json",
        address: $('#search').val()
        //address: "渋谷"
    }

    console.log(params);
    
    $.getJSON(url, params, function(result) {
          html += showResult(result);
    });

  });
  $('.container').appendTo(html);
});