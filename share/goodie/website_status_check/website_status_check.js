DDH.website_status_check = DDH.website_status_check || {};

    
DDH.website_status_check.build = function(ops) {
    "use strict";
    
    var myMap={
        '0':{
            'color':'#d3263a',
            'content':'Website is down'
        },
        '1':{
            'color':'#2bdb51',
            'content':'Website is up'
        },
        'enter url':{
            'color':'#3496bc',
            'content':'Enter a valid url'
        },
        'invalid api call':{
            'color':'#3496bc',
            'content':'Enter a valid url'
        },
        
    }
    
    return {
        onShow: function() {
  
            var $dom = $('.zci--website_status_check'),
                $statusCheckButton = $dom.find('button'),
                $baseUrl='http://websitestatus.herokuapp.com/check?url=',
                $status='',
                $insertHTML='',
                $inputUrl = $dom.find('input')[0],
                $resultDiv=$dom.find('.result')[0]
            var $url='';
            $statusCheckButton.on('click',function(){
                $url=$inputUrl.value;
                console.log($baseUrl+$url);
                $.ajax({
                    url:$baseUrl+$url,
                    method:'GET',
                    success:function(result){
                        $status=result.status;
                        $($resultDiv).removeClass('is-hidden');
                        $insertHTML='<h2 style="color:'+myMap[$status].color+';font-weight:bold">'+myMap[$status].content+'</h2>'
                        $($resultDiv).html($insertHTML);
                    }
                })
            });
    }
    }
}