# Traffic Light Controller

## Test bench

| Feature                                                       | Input                                              | Expected Output                                                        | Comment |
|---------------------------------------------------------------|----------------------------------------------------|------------------------------------------------------------------------|---------|
| Resetting                                                     | Reset                                              | Counter is set to 0, Traffic is set to default T1                      |         |
| If all congested loop in order T1 to T4 waits 60s             | all sensors fire                                   | T1 for 60s then T2 for 60s then T3 for 60s then T4 for 60s then repeat |         |
| If sensors for T1 are all fired then it waits 60s or else 30s | once sensor 1 and sensor 2 the other sensor 1 only | For first time wait 60s then second time 30s                           |         |
| Fire the next congested Traffic in order                      | in T1, T4 is congested and T2, T3 are empty        | T1 switches to T4 in the next clock                                    |         |

