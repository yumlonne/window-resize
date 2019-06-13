window.onload = () => {
	const app = Elm.Main.init();
    var myWindow;

    app.ports.popup.subscribe(() => {
        myWindow = open("/yumlonne.jpeg", null, "width=300, height=300");
    })

    app.ports.resizeWindow.subscribe(([width, height]) => {
        if (myWindow != null) {
            myWindow.resizeTo(width, height);
        }
    })
};
