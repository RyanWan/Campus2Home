import sqlalchemy
from sqlalchemy import Table, Column, Integer, String, ForeignKey

# user = CSE438
# password = cse438
# db = timetable



def connect(user='cse438', password='cse438', db='timetable', host='localhost', port=5432):
    url = 'postgresql://{}:{}@{}:{}/{}'
    url = url.format(user, password, host, port, db)
    con = sqlalchemy.create_engine(url, client_encoding='utf8')
    meta = sqlalchemy.MetaData(bind=con, reflect=True)
    return con, meta

def create_table(con, meta):
    times = Table('times', meta,
        Column('time', String),
        Column('address', String),
        Column('geocode', String),
        extend_existing=True,
    )
    times.extend_existing =True

    meta.create_all(con)

def clear_table(con, meta):
    con.execute(meta.tables['times'].delete())


def drop_table(con, meta):
    meta.drop_all(con)

def insert_address(con, meta, time, address, geocode):
    times = meta.tables['times']
    clause = times.insert().values(time=time, address=address, geocode=geocode)
    con.execute(clause)

def select_time(con, meta, time):
    times = meta.tables['times']
    clause = times.select().where(times.c.time == time)
    ret = []
    for row in con.execute(clause):
        ret.append([row[1],row[2]])
    return ret



# con, meta = connect()
# create_table(con, meta)
# insert_address(con, meta, '6:30', '6170', '1,-1')
# insert_address(con, meta, '6:30', '6170', '1,-1')
# print(select_time(con, meta, '6:30'))
# print(select_time(con, meta, '7:30'))
# ##clear_table(con, meta)
# print(select_time(con, meta, '6:30'))
