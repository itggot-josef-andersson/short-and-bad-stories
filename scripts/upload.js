(function() {
    document.getElementById('sharing_form').onsubmit = function() {
        var si = document.getElementById('story_input');
        si.value = encodeURI(si.value);
    };
})();
