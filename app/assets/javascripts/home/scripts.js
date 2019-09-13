
$(function(){
  var search_box = $('#search');
  console.log("hi");
  search_box.click(function(){
    var ajax = new XMLHttpRequest();
    
    ajax.open("get", `https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=6463bc55622ce5ad6df3afe4bd4d9815&address=${search_box.text}`);
    ajax.responseType = 'json';
    ajax.send();
    var html = "";

    ajax.onload = function (e) {
      console.log(e.target.response.rest);
      for (var i = 0; i < e.target.response.rest.length; i++) {
      	console.log(e.target.response.rest[i]);
      	html +=  
      	 '<div class="shops-index-item">'
      	+	'<div class="shop-name">'
      	+		'<%= link_to("店名{shop.shop_id}", "https://www.gnavi.co.jp/", target: "_blank") %>'
      	+	'</div>'
      	+'</div>'
      }
    }
    
    $('.container').append(html);

  });

});