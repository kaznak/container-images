##################################################################
##################################################################
##################################################################
FROM postgres:16-bookworm AS builder

RUN echo '/var/lib/apt/lists/*' ./del.lst > ./del.lst

# Set locale
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8

##################################################################
# update repository
RUN apt update

# build and install extentions
COPY pkg.lst ./
RUN ls ./pkg.lst >> ./del.lst
RUN apt install -y $(sed -e 's/#.*$//' ./pkg.lst)

# setup postgres apt respository
# https://wiki.postgresql.org/wiki/Apt
RUN yes | /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

# setup pgroonga apt respository
# https://pgroonga.github.io/ja/install/debian.html
RUN wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN ls ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb >> ./del.lst
RUN apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
RUN wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb
RUN ls ./groonga-apt-source-latest-$(lsb_release --codename --short).deb >> ./del.lst
RUN apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb

##################################################################
# install apt packages

RUN apt update
RUN apt install -y -V       \
        postgresql-16-pgdg-pgroonga     \
        groonga-tokenizer-mecab \
        \
        postgresql-16-pgvector

##################################################################
# install pgx packages

# pgvector
RUN git clone --branch v0.5.1 https://github.com/pgvector/pgvector.git
RUN ls -d ./pgvector >> ./del.lst
RUN cd pgvector && make && make install && cd ../

# pldebugger
RUN git clone https://github.com/EnterpriseDB/pldebugger.git
RUN ls -d ./pldebugger >> ./del.lst
RUN cd pldebugger && git checkout v1.5 && USE_PGXS=1 make install && cd ../

##################################################################
# install deb packages

RUN curl -LO https://github.com/kaznak/pgx_uuidv7/releases/download/v0.1.1/pgx-uuidv7-16-amd64-linux-gnu.deb
RUN ls -d ./pgx-uuidv7-16-amd64-linux-gnu.deb >> ./del.lst
RUN dpkg -i ./pgx-uuidv7-16-amd64-linux-gnu.deb

##################################################################
# clean up build and install environment
RUN apt remove -y --purge --auto-remove $(grep -E '#.* remove($| )' pkg.lst | sed -e 's/#.*$//')
RUN apt-get clean

RUN rm -rf $(tr '\n' ' ' < ./del.lst)

# remove the line `. "$HOME/.cargo/env"` from $HOME/.bashrc and $HOME/.profile
RUN sed -i '$d' $HOME/.bashrc
RUN sed -i '$d' $HOME/.profile

##################################################################
##################################################################
##################################################################
FROM postgres:16-bookworm

# merge image layers
COPY --from=builder / /

# ENV LANG        ja_JP.UTF-8
# # https://www.postgresql.org/docs/current/locale.html
# # https://www.postgresql.jp/document/15/html/locale.html
# ENV LC_COLLATE  ja_JP   # 文字列の並び換え順
# ENV LC_CTYPE    ja_JP   # 文字の分類（文字とはどんなもの？大文字小文字を区別しない？）
# ENV LC_MESSAGES ja_JP   # メッセージの言語
# ENV LC_MONETARY ja_JP   # 通貨書式
# ENV LC_NUMERIC  ja_JP   # 数字の書式
# ENV LC_TIME     ja_JP   # 日付と時刻の書式

# ENV PGDATA /var/lib/postgresql/data/16
# A k8s pv makes a lost+found directory on the root of the directory.
# Postgres rejects that existence and stops.
# Then, this directory change is necessary.
# Changing the mount point without consideration causes loss volume persistency.
