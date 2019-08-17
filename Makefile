config ?= config.sh
include $(config)


# publish: stats
# 	./convert-$(FORMAT).sh
#
# stats: convert
# 	echo "Give stats"
#
# convert: convertLight convertFull
# 	echo "shortdata $(FORMAT)" && echo "fulldata $(FORMAT)"
#
# convertLight: download
# 	echo "Make sireneCompact.ttl"
#
# convertFull: download
# 	echo "Make sireneFull.ttl"

download:
	departements=$(DEPARTEMENTS) ./scripts/download.sh

clean:
	rm -r csv rdf
