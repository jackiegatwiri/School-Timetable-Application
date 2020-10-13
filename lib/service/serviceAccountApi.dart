import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

final accountCredentials = new ServiceAccountCredentials.fromJson({
  "private_key_id": "78e081d1df31abf875b5abfc89947559c7003a72",
  "private_key":
      "\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCvkeg2kTdaqsMT\n0YcsQ264Z/CWSTd1ucCkrxpelNY8KSqMoFiSfrPm38y1Dcpn31EBDNdXbJeQOTvj\nBcO6sL6qw16RcOT+BcQb30DZ4/x5g5l3Wy9WqHcE1Oi7C2k65Ao7U0ThQBz/wYBI\nAcvPfpYj+aNUZH4ywTl/C0BJQD+pg35WPSgqyvKMKR/WoErHMhFP0a3ekLjKmZvt\nI1nhuBaU6e/zmUnZDLHKXWvg3f6iNG1l/7vTcOi6EAHFiECAXys9QevZoyLiRLKq\nsSgXThfo+6vnMIshXkcNtnEKo4088bQ1QTHg05fKGx3wNpHIMpOKZT7/d6JxHVw/\noKeq5KlnAgMBAAECggEAHAtl+OVsXqa9P3quKWNiGcG8m/z5B2yS+Ztgzm/e4sA+\npDTuwQPNL9la5SbdSIdS9KR892GIukhyKPrgP3+BDVzky72pTmxUXZFlVgjFaRGc\n34RoxOJnFJX/0PTrK7WGbuCHtaVcnHvnxljHGg9h40A6lz3wLKJR0VnWPH0vTh/H\nIRe+byIfZvdwjM6Dby+FOrD/r3D+yETwVdYLl8thwg/VzmbLRKOsFbKBRPOYeU+l\nU0YtNYWfSEZzK0x41iYggBhnl31pMnV6EHNP5hSC0aeFM/GfLvpKG0U+acv7jVGm\n0SWc1abebakKelmGS6zwfAzPAx/KrMEWgCIGiKQxtQKBgQDy1VohtlumvBpBANog\noalZtQ1Vat2awGrI2q8R+uK2VF8C1NSKl2sUvlXQeOV7LwBdK5p8vE60taxVdmbC\nR7ezBUeHQQYlKtXUAU9GNoXlDe5qlYjOVdtcGU9baeUjEZ2hoP5/oPZfHDSNz/XH\nxbVpPFXQ3/BezDt/ZSie0hV65QKBgQC5FueonUjHnErLm6HkmxyLre7/MfZJsk0J\nBhhxxXp6XuaCyXtOf8iNLeiylwMOG7cS9Ou1eyfn5LP+oOPwMAwSLXcOdVmdaAmz\notTlCQk5o0A+8qFKaFApKj4VE6H6YZZp71SC/0y+TAXitfyegCdmafSaLeNKbdRF\nqMCsCehyWwKBgQDb15PV2YZ4GOub1e2khTcQY/1CS5F8vJ7wYCsHGB+P+ipaIdyZ\n7COhj/+Y0RrQvuiRcRxXuRN4PtFaPesiEFOa2zi6ln+9vl3/pX/jjREDIe2qyN4m\nD0ycwL07gU9UxGn1Hg/J9CuYR6y8hn148uEd+OWoSFURPczPtQFlZ8TSkQKBgQCs\n2XIgKjp0h0XmXYJT7nM7EoT2d58sdcGxYqrjXOujagrVKvnndjhBeBUu6w4kV8eh\ngW66fbfnvNJHQdN8VDKBq0nbC8ZT1Hvy8WbmOYkO9aEi6A2uYjoyJ0vw/POw0v/Y\nEHSZHXh64p5AeXngP4gMAXk3nxD7ShQJta2xPFOCrwKBgQCOaG2hk9tIjH0li83N\nErYTB4Sm+cPY9cQ0pTELejpdZDI+7p4FnlD85CSbgrvYyyjLTNfihP8DQJk1+Atv\npTLG+SeRS14sQtcAQfHYnNgIWWdcVP9hk18Dx4NV3lL8WL6w6rrjzT4sA7EshOEf\n2oY6E7viILfud0R5eatPQw/EnQ==\n",
  "client_email":
      "schooltimeserviceaccpunt@schooltimetableapi.iam.gserviceaccount.com",
  "client_id": "103581344848195440161",
  "type": "service_account"
});
var _scopes = [
  CalendarApi.CalendarScope
]; //defines the scopes for the calendar api

void getCalendarEvents() {
  clientViaServiceAccount(accountCredentials, _scopes).then((client) {
    var calendar = new CalendarApi(client);
    var calEvents = calendar.events.list("primary");
    calEvents.then((Events events) {
      events.items.forEach((Event event) {
        print(event.summary);
      });
    });
  });
}
