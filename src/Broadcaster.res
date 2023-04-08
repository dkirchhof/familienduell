/* type event = BuzzerPressed(Team) */

/* module BroadcastChannel = { */
/*   type t */

/*   @send external sendEvent: (t, event) => unit = "postMessage" */
/*   @send external addEventListener: (t, @as("message") _, event => unit) => unit = "addEventListener" */
/*   @send external close: t => unit = "close" */
/* } */

/* @new external make: string => BroadcastChannel.t = "BroadcastChannel" */

/* let bc = make("familienduell") */

/* let listen = callback => { */
/*   BroadcastChannel.addEventListener(bc, callback) */
/* } */

/* let unlisten = () => { */
/*   BroadcastChannel.close(bc) */
/* } */

/* let sendEvent = event => { */
/*   BroadcastChannel.sendEvent(bc, event) */
/* } */
