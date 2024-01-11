function onMessage(e) {
  console.log(e);
}

channel = new MessageChannel();

const params = new Proxy(new URLSearchParams(window.location.search), {
  get: (searchParams, prop) => searchParams.get(prop),
});

var homeTeam = params.home_team;
var awayTeam = params.away_team;

channel.port1.onmessage = onMessage;
window.postMessage("Message is sent.", '*', [channel.port2]);

function getHomeTeam() {
	return homeTeam;
}

function getAwayTeam() {
	return awayTeam;
}
