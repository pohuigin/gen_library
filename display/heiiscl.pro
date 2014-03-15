;Scale a HeII 304 angstrom image.
;Currently calibrated for AIA

;TODO: make an option for separately scaling ON/OFF limb parts of the image.
;want to bring out the prominences and make ARs less saturated.

function heiiscl,image

aiaalpha=0.1
aiaran=[0.97,1.85]

outdata=(float(image)^(aiaalpha))<aiaran[1]>aiaran[0]








return,outdata

end