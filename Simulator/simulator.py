import simpy
import configuration

all_edge = dict()
all_bus_stop = dict()

env = simpy.Environment()

def get_shelter_index(a):
    assert(a == 5 or a == 6)
    return 0 if a == 5 else 1

class Edge(object):
    """A carwash has a limited number of machines (``NUM_MACHINES``) to
    clean cars in parallel.

    Cars have to request one of the machines. When they got one, they
    can start the washing processes and wait for it to finish (which
    takes ``washtime`` minutes).

    """
    def __init__(self, env, passing_time, capacity, from_node, to_node):
        self.env = env
        self.machine = simpy.Resource(env, capacity)
        self.passing_time = passing_time
        self.from_node = from_node
        self.to_node = to_node

    def pass_the_edge(self, fleet_name):
        """The washing processes. It takes a ``car`` processes and tries
        to clean it."""
        yield self.env.timeout(self.passing_time)
        print("%s passed edge(%d, %d) at %.2f." %
              (fleet_name, self.from_node, self.to_node, env.now))

class Bus_Stop(object):
    """A carwash has a limited number of machines (``NUM_MACHINES``) to
    clean cars in parallel.

    Cars have to request one of the machines. When they got one, they
    can start the washing processes and wait for it to finish (which
    takes ``washtime`` minutes).

    """
    def __init__(self, env, number, evacuee1, evacuee2):
        self.env = env
        self.number = number
        self.machine = simpy.Resource(env, configuration.NUMBER_OF_LANE)
        self.standing_time = configuration.BUS_STOP_STANDING_TIME
        self.number_of_evacuee = [evacuee1, evacuee2]


def route(env, fleet_number, capacity, route, interval, trip, stop_list=None):
    """The car process (each car has a ``name``) arrives at the carwash
    (``cw``) and requests a cleaning machine.

    It then starts the washing process, waits for it to finish and
    leaves to never come back ...

    """
    yield env.timeout(interval)
    size = len(route)
    print('%s starts at %.2f.' % (fleet_number, env.now))
    vacancies = capacity
    des_shelter_index = get_shelter_index(route[-1])
    start_index = 1
    for trip_number in range(1, trip + 1):
        start_index = 1
        for _ in range(start_index, size):
            node1 = route[_ - 1]
            node2 = route[_]

            # first check if node1 in stop list
            if stop_list is not None and node1 in stop_list:
                if all_bus_stop[node1].number_of_evacuee[des_shelter_index] > 0 and vacancies > 0:
                    with all_bus_stop[node1].machine.request() as request:
                        yield request
                        yield env.timeout(configuration.BUS_STOP_STANDING_TIME)
                        print('%s stops at bus stop (%d) at %.2f.' % (fleet_number, node1, env.now))
                        evacuee = min(vacancies, all_bus_stop[node1].number_of_evacuee[des_shelter_index])
                        all_bus_stop[node1].number_of_evacuee[des_shelter_index] -= evacuee
                        vacancies -= evacuee

            print('%s request (%d, %d) at %.2f.' % (fleet_number, node1, node2, env.now))
            with all_edge[node1,node2].machine.request() as request:
                yield request
                yield env.process(all_edge[node1,node2].pass_the_edge(fleet_number))

        print('Trip %d of %s goes to shelter at %.2f.' % (trip_number, fleet_number, env.now))
        # capacity will be zero
        vacancies = capacity
        # yield give times to get off the bus
        yield env.timeout(configuration.SHELTER_EVACUATION_TIME)
        if trip_number == trip:
            print('%s done all the trips at %.2f.' % (fleet_number, env.now))
            # no backward journey required
            break

        for _ in range(size - 1, 0, -1):
            node1 = route[_]
            node2 = route[_ - 1]

            print('%s request (%d, %d) at %.2f.' % (fleet_number, node1, node2, env.now))
            with all_edge[node1,node2].machine.request() as request:
                yield request
                yield env.process(all_edge[node1,node2].pass_the_edge(fleet_number))
                if all_bus_stop[node2].number_of_evacuee[des_shelter_index] == 0:
                    start_index = _
                    break

        print('Trip %d of %s goes to start node %d at %.2f.' % (trip_number, fleet_number, start_index, env.now))




# fleet.txt contains description of all fleets
f = open('bus_fleet.txt', 'r')
fleet_name = f.readline().strip()
route_list = []
while fleet_name:
    route_des = f.readline()
    route_list = [int(_) for _ in route_des.split()]
    delay =  float(f.readline())
    trip_count = int(f.readline())
    env.process(route(env, fleet_name, 50, route_list, delay, trip_count))
    fleet_name = f.readline().strip()

# bus_stop.txt contains description of all bus stops
f = open('bus_stop.txt', 'r')
for line in f:
    l = [int(_) for _ in line.split()]
    all_bus_stop[l[0]] = Bus_Stop(env, l[0], l[1], l[2])

# bus_stop.txt contains description of all bus stops
f = open('bus_route.txt', 'r')
for line in f:
    l = [int(_) for _ in line.split()]
    l[2] = l[2] * 1 #hypeparameter
    assert(l[3] == 1 or l[3] == 2)
    if l[3] == 2:
        all_edge[l[0], l[1]] = Edge(env, l[2], configuration.NUMBER_OF_LANE, l[0], l[1])
        all_edge[l[1], l[0]] = Edge(env, l[2], configuration.NUMBER_OF_LANE, l[1], l[0])
    else:
        all_edge[l[0], l[1]] = Edge(env, l[2], configuration.NUMBER_OF_LANE/2, l[0], l[1])
        all_edge[l[1], l[0]] = Edge(env, l[2], configuration.NUMBER_OF_LANE/2, l[1], l[0])


# Execute!
env.run(until=configuration.SIM_TIME)


