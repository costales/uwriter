function openFile(fileUrl) {
    var request = new XMLHttpRequest()
    request.open('GET', "/home/phablet/.local/share/uwp.costales/" + fileUrl)
    request.onreadystatechange = function(event) {
        if (request.readyState == XMLHttpRequest.DONE) {
            var text = request.responseText;
            mainPageStack.executeJavaScript("tinyMCE.activeEditor.setContent('" + text + "')");
        }
    }
    request.send();
}

function saveFile(fileUrl, text) {
    var request = new XMLHttpRequest();
    request.open("PUT", "/home/phablet/.local/share/uwp.costales/" + fileUrl + '.html');
    request.send(unescape(text.replace(/'/g, '&#39;')));
}

function url_starts_with(url, start) {
    if (url.substring(0, start.length) == start)
        return true;
    else
        return false;
}

function getTranslators(translators_string) {
	var all_translators = [];
	
	if (translators_string === '' || translators_string === 'translator-credits') {
		all_translators.push({
			name: "Ubuntu Translators Community",
			link: "https://translations.launchpad.net/+groups/ubuntu-translators"
		});
		return all_translators;
	}
	
	var translators = translators_string.split('\n');
	translators.forEach(function(translator) {
		if (translator.indexOf("https://launchpad.net") > -1 && translator.indexOf("costales https://launchpad.net/~costales") < 0) { // First string will be the header and don't include myself
			var translator_name = translator.split(' https://launchpad.net/~')[0].trim();
			var translator_link = 'https://launchpad.net/~' + translator.split('https://launchpad.net/~')[1];
			all_translators.push({
				name: translator_name,
				link: translator_link
			});
		}
	});
	
	return all_translators;
}
