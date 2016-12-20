var BASEUSERID = '12185661707';
var PLAYLISTID = '3M8IPD8akAgx29Wn1m4Uec';

var options = {
    valueNames: [
	'user',
	'userid',
	'artist',
	'name',
	{attr:'trackid', name:'cbox'},
	'voted'
    ],
    item: '<tr><td align="center"><input class="cbox" type="checkbox" onclick="voteThisTrack(this);"/>&nbsp;</td><td class="user"></td><td class="artist"></td><td class="name"></td></tr>'
};
var curlimit = 0;
var curitem = {};
// Build UserID -> User Name mapping
var usersmap = {};
var myid = "";
var myvotes = null;

var ghostusers = {_biads: "Bia Duarte Scoczynski",
		  _22geupxsvp32yjj5vlyfnd3sy: "Gustavo Scopel Ferreira da Costa"};

function getHashParams() {
    var hashParams = {};
    var e, r = /([^&;=]+)=?([^&;]*)/g,
	q = window.location.hash.substring(1);
    while ( e = r.exec(q)) {
	hashParams[e[1]] = decodeURIComponent(e[2]);
    }
    return hashParams;
}

function fillTrackTable(userId,
			playlistId,
			useoffset,
			uselimit)
{
    spotifyApi.getPlaylistTracks(userId,
			   playlistId,
			   {limit: uselimit, offset: useoffset})
	.then(function(data) {
	    return data.items
	})
	.then(function(trackItems) {
	    for (var t=0; t<uselimit; t++) {
		userList.add({
		    user: trackItems[t].added_by.id,
		    userid: trackItems[t].added_by.id,
		    artist: trackItems[t].track.artists[0].name,
		    name: trackItems[t].track.name,
		    cbox: trackItems[t].track.id,
		    voted: 0
		});
	    }
	    return trackItems.map(function(a) {return a.added_by.id})
	})
	.then(function(userids) {
	    var unique = userids.filter(function(item, i, ar)
					{ return ar.indexOf(item)=== i; });
	    for (var i=0; i<unique.length; i++) {
		if (!(unique[i] in usersmap)) {
		    usersmap[unique[i]] = spotifyApi.getUser(unique[i])
		}
	    }
	    return usersmap
	})
	.then(function(usersmap) {
	    // Search and replace
	    for (var id in usersmap) {
		if (usersmap.hasOwnProperty(id)) {
		    usersmap[id]
			.then(function(userInfo) {
			    userList.items.map(function(a) {
				if (a._values.user == userInfo.id) {
				    if (userInfo.display_name !== null) {
					a._values.user = userInfo.display_name;
				    } else {
					a._values.user = ghostusers['_'+userInfo.id];
				    }
				}
			    });
			    userList.update()
			    var userCells = document.querySelectorAll('.user')
			    userCells.forEach(
				function(val, key, listObj) {
				    if (val.innerText == userInfo.id) {
					if (userInfo.display_name !== null) {
					    val.innerText = userInfo.display_name;
					} else {
					    val.innerText = ghostusers['_'+userInfo.id];
					}
				    }
				})
			})
			.catch(function(err) {
			    console.error(err)
			});
		}
	    }
	    userList.filter(function(item) {
		if (item.values().userid == myid) {
		    return false;
		} else {
		    return true;
		}
	    });
	    if (myvotes !== null) {
		myvotes.votes.map(function(a) {
		    if (a.vote > 0) {
			var chk = document.querySelector('input[trackid="'+a.trackid+'"]');
			chk.checked = true;
			voteThisTrack(chk);
		    }
		});
	    }
	})
	.catch(function(err) {
	    console.error(err)
	});
}

function voteThisTrack(cb) {
    var itemlist = userList.get("cbox",cb.getAttributeNode("trackid").value);
    if (cb.checked == true) {
	itemlist[0]._values.voted = 1;
    } else {
	itemlist[0]._values.voted = 0;
    }
}

function checkAllVisible(cb) {
    if (cb.checked == true) {
	var chkboxes = document.querySelectorAll('.cbox');
	chkboxes.forEach(
	    function(val, key, listObj) {
		val.checked = true;
		voteThisTrack(val);
	    });
    }
    setTimeout(function(){cb.checked = false;},500);
}

function uncheckAllVisible(cb) {
    if (cb.checked == true) {
	var chkboxes = document.querySelectorAll('.cbox');
	chkboxes.forEach(
	    function(val, key, listObj) {
		val.checked = false;
		voteThisTrack(val);
	    });
    }
    setTimeout(function(){cb.checked = false;},500);
}

function saveVotingState() {

    var ballot = {};
    ballot['userid'] = myid;
    ballot['votes'] = [];
    var savemsgElem = document.querySelector('#savemsg');
    userList.items.map(function(a) {
	ballot['votes'].push(
	    { trackid: a._values.cbox,
	      vote: a._values.voted
	    }
	);
    });
    emailjs.send("gmail","play_list_do_ano_novo",{from_name: myid, ballot: JSON.stringify(ballot)})
	.then(function(response) {
	    console.log("SUCCESS. status=%d, text=%s", response.status, response.text);
	    var currentdate= new Date();
	    savemsgElem.innerText = "Sucesso! Salvo pela última vez em:" +
		currentdate.getDate() + "/"
		+ (currentdate.getMonth()+1)  + "/" 
		+ currentdate.getFullYear() + " @ "  
		+ currentdate.getHours() + ":"  
		+ currentdate.getMinutes() + ":" 
		+ currentdate.getSeconds();
	}, function(err) {
	    console.log("FAILED. error=", err);
	    savemsgElem.innerText = "PUTS. Algo deu errado. Avise o Violato."
	});
}

function saveTest() {

    var savemsgElem = document.querySelector('#savemsg');
    var currentdate= new Date();
    savemsgElem.innerText = "Sucesso! Salvo pela última vez em: " +
	currentdate.getDate() + "/"
        + (currentdate.getMonth()+1)  + "/" 
        + currentdate.getFullYear() + " às "  
        + currentdate.getHours() + ":"  
        + currentdate.getMinutes() + ":" 
        + currentdate.getSeconds();
}


var spotifyApi = new SpotifyWebApi();
var params = getHashParams();
spotifyApi.setAccessToken(params.access_token);

var userList = new List('playlist', options);

spotifyApi.getMe()
    .then(function(userInfo) {
	myid = userInfo.id

	$.getJSON("ballot_"+myid+".json", function(json) {
	    myvotes = json;
	})
	    .fail(function() {
		console.log("No ballot file, will be created when saved.")
		return null;
	    });
	
	spotifyApi.getPlaylistTracks(BASEUSERID,
				     PLAYLISTID,
				     {fields: ['total', 'limit']})
	    .then(function(data) {
		//var tot = data.total;
		var tot = 50;
		for (var off=0; off<tot; off=off+data.limit) {
		    if ((off+data.limit)>=tot) {
			curlimit=tot-off;
		    } else {
			curlimit = data.limit;
		    }
		    fillTrackTable(BASEUSERID,
				   PLAYLISTID,
				   off,
				   curlimit)
		}
	    })
	    .catch(function(err) {
		console.error(err);
	    });
    })
    .catch(function(err) {
	console.error(err);
    });

