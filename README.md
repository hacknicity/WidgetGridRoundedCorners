This is an experiment to try and solve Charlie Chapman's ContainerRelativeShape() problem: https://twitter.com/_chuckyc/status/1440862697168334852

My idea was to use a ZStack to render all the rows (or columns) at the top (or left) with a ContainerRelativeShape() clipShape and then .offset them to where they ought to appear.

It did not work and the inner cells did not have rounded corners:

<p>
	<img src="screenshot.png" width="1000" title="screenshot" />
</p>
