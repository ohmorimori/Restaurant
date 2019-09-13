function get_info() {
  var ajax = new XMLHttpRequest();
  console.log("hi");
  ajax.open("get", "https://api.gnavi.co.jp/RestSearchAPI/v3/");
  ajax.responseType = 'json';
  ajax.send();
  ajax.onload = function (e) {
    console.log(e.target.response);
  };
  console.log(ajax);


  /*
  $.ajax({
    type : "get",
    //url　: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=【ぐるなびアクセスキー】&wifi=1&latitude="+lat+"&longitude="+lng+"&range=4&category_l=RSFST20000,RSFST18000",
    url　: "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=e85120cf9553ac27ca3926752a813443&address=渋谷",
    dataType : 'json',
    success　: function(json){
      let num_shop = json.rest.length;
      console.log(num_shop);
    },
    error: function(json){
      console.log("error")
    }
  });
  */
}

get_info();

