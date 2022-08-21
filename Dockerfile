FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake zlib1g zlib1g-dev autotools-dev autoconf libgd-dev libmad0-dev libid3tag0-dev libsndfile1-dev libgd-dev libboost-filesystem-dev libboost-program-options-dev   libboost-regex-dev
RUN git clone https://github.com/bbc/audiowaveform.git
WORKDIR /audiowaveform
RUN git clone https://github.com/google/googletest.git
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ -DBUILD_SHARED_LIBS=true .
RUN make
RUN make install
RUN mkdir /audiowaveformCorpus
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/trailing-garbage.mp3
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/bear-audio-10s-CBR-no-TOC.mp3
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/icy_sfx.mp3
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/id3_test.mp3
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/midstream_config_change.mp3
RUN mv *.mp3 /audiowaveformCorpus


ENTRYPOINT ["afl-fuzz", "-i", "/audiowaveformCorpus", "-o", "/audiowaveformOut"]
CMD ["/audiowaveform/audiowaveform", "-i", "@@", "-o", "out.wav"]
